<%@ WebService Language="c#" Codebehind="ConverterService.asmx.cs" Class="WebServiceTests.ConverterService" %>

/*
WARNING: This code was generated by a tool.
Changes to this file will be lost if the code is regenerated
*/

using System;
using System.Collections;
using System.Xml;
using System.Xml.Serialization;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Services.Description;

namespace WebServiceTests
{
	public class UserInfo : SoapHeader 
	{
		public int userId;
	}
	
	public class CurrencyInfo
	{
		public CurrencyInfo ()
		{
		}

		public CurrencyInfo (string name, double rate) 
		{
			Name = name;
			Rate = rate;
		}
		
		public string Name;
		public double Rate;
	}
	
	public class Simple
	{
		public int Dada;
	}

	[WebServiceAttribute (Namespace="urn:mono-ws-tests", Description="Web service that can make currency conversions")]
	[SoapDocumentServiceAttribute (Use=SoapBindingUse.Literal, ParameterStyle=SoapParameterStyle.Wrapped)]
	public class ConverterService : System.Web.Services.WebService
	{
		static int userCount = 0;
		static Hashtable conversionTable;
		
		public UserInfo userInfo;
		
		public SoapHeader unknown1;
		public SoapHeader[] unknown2;
		public SoapUnknownHeader unknown3;
		public SoapUnknownHeader[] unknown4;

		static ConverterService ()
		{
			conversionTable = new Hashtable ();
			InternalSetCurrencyRate ("USD", 1);
			InternalSetCurrencyRate ("EUR", 0.883884 );
			InternalSetCurrencyRate ("GBP", 0.611817 );
			InternalSetCurrencyRate ("JPY", 118.271 );
			InternalSetCurrencyRate ("CAD", 1.36338 );
			InternalSetCurrencyRate ("AUD", 1.51485 );
			InternalSetCurrencyRate ("CHF", 1.36915 );
			InternalSetCurrencyRate ("RUR", 30.4300 );
			InternalSetCurrencyRate ("CNY", 8.27740 );
			InternalSetCurrencyRate ("ZAR", 7.62645 );
			InternalSetCurrencyRate ("MXN", 10.5025 );
		}
		
		[WebMethod (Description="Registers the user into the system")]
		[SoapHeaderAttribute ("userInfo", Direction = SoapHeaderDirection.Out)]
		public void Login (string a)
		{
			userInfo = new UserInfo ();
			userInfo.userId = ++userCount;
		}

		[WebMethod (Description="Converts an amount from one currency to another currency")]
		[SoapHeaderAttribute ("userInfo")]
		public double Convert (string sourceCurrency, string targetCurrency, double value)
		{
			CheckUser ();
			double usd = (1 / GetCurrencyRate (sourceCurrency)) * value;
			return usd * GetCurrencyRate (targetCurrency);
		}
		
		[WebMethod (Description="Returns a list of currency rates")]
		[SoapHeaderAttribute ("userInfo")]
		public CurrencyInfo[] GetCurrencyInfo ()
		{
			CheckUser ();
			
			lock (conversionTable)
			{
				CurrencyInfo[] info = new CurrencyInfo[conversionTable.Count];
				int n = 0;
				foreach (CurrencyInfo cinfo in conversionTable.Values)
					info [n++] = cinfo;
				return info;
			}
		}
		
		[WebMethod (Description="Sets the rate of a currency")]
		[SoapHeaderAttribute ("userInfo")]
		public void SetCurrencyRate (string currency, double rate)
		{
			CheckUser ();
			InternalSetCurrencyRate (currency, rate);
		}

		static void InternalSetCurrencyRate (string currency, double rate)
		{
			lock (conversionTable)
			{
				conversionTable [currency] = new CurrencyInfo (currency, rate);
			}
		}

		[WebMethod (Description="Returns the rate of a currency")]
		[SoapHeaderAttribute ("userInfo")]
		public double GetCurrencyRate ([XmlElement(DataType="Name")]string cname)
		{
			CheckUser ();
			lock (conversionTable)
			{
				if (!conversionTable.ContainsKey (cname))
					throw new SoapException ("Unknown currency '" + cname + "'", SoapException.ServerFaultCode);
					
				return ((CurrencyInfo) conversionTable [cname]).Rate;
			}
		}
		
		[WebMethod]
		public void Test (Simple dada1, int dada)
		{
			dada = 1;
		}
		
		[WebMethod (MessageName="Test2")]
		public void Test (int[] dada2, byte[] dada3, int dada)
		{
			dada = 1;
		}
		
		[WebMethod]
		public System.Collections.Specialized.StringCollection TestArrays (string[] info, string lang)
		{
			return null;
		}
		
		void CheckUser ()
		{
			if (userInfo == null) 
				throw new SoapException ("User not logged", SoapException.ServerFaultCode);
		}
		
		[WebMethod]
		[return: XmlElement("retret")]
		public MyInfo GetTestInfo (string s, out string d)
		{
			d = "iii";
			return new MyInfo();
		}
		
		[SoapHeaderAttribute ("unknown1")]
		[WebMethod]
		public void TestUnknownHeader1 ()
		{
			if (unknown1 == null)
				throw new Exception ("Header is null");

			if (unknown1.Actor != "hi")
				throw new Exception ("Invalid actor");
		}
		
		[SoapHeaderAttribute ("unknown2")]
		[WebMethod]
		public void TestUnknownHeader2 ()
		{
			if (unknown2 == null || unknown2.Length != 1)
				throw new Exception ("Header is null");

			if (unknown2[0].Actor != "hi")
				throw new Exception ("Invalid actor");
		}
		
		[SoapHeaderAttribute ("unknown3")]
		[WebMethod]
		public int TestUnknownHeader3 ()
		{
			if (unknown3 == null)
				throw new Exception ("Header is null");

			if (unknown3.Actor != "hi")
				throw new Exception ("Invalid actor");
				
			XmlElement child = unknown3.Element ["userId"];
			return int.Parse (child.InnerText);
		}
		
		[SoapHeaderAttribute ("unknown4")]
		[WebMethod]
		public int TestUnknownHeader4 ()
		{
			if (unknown4 == null || unknown4.Length != 1)
				throw new Exception ("Header is null");

			if (unknown4[0].Actor != "hi")
				throw new Exception ("Invalid actor");
				
			XmlElement child = unknown4[0].Element ["userId"];
			return int.Parse (child.InnerText);
		}
	}

	public class MyInfo
	{
		public int a = 4;
		public string b = "hi";
	}
}
