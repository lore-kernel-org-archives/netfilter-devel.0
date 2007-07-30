From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH] ipt_ROUTE for kernel 2.6.21.5
Date: Mon, 30 Jul 2007 17:17:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707301709370.4354@bizon.gios.gov.pl>
References: <2cb453e80707300742i66b81b95pde18e37a6db046d5@mail.gmail.com>
	<Pine.LNX.4.64.0707301644360.26373@fbirervta.pbzchgretzou.qr>
	<46ADF9FA.4000901@trash.net>
	<Pine.LNX.4.64.0707301649000.26373@fbirervta.pbzchgretzou.qr>
	<46ADFACE.5040304@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1046843135-1185808635=:4354"
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Ludovic <ludovic.mailinglist@gmail.com>,
	netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46ADFACE.5040304@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1046843135-1185808635=:4354
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 30 Jul 2007, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>> On Jul 30 2007 16:47, Patrick McHardy wrote:
>>
>>> Fully agreed (well, I made that argument for ages), I think we
>>> should simply remove it from pomng to avoid misleading users
>>> into thinking it would be the proper way to do things.
>>>
>>
>> I second that idea.
>
>
> Its gone now ..

1. ROUTE has a very usefull option --tee. AFAIK it is not possible to do=20
it other way.
2. Policy routing based on fwmark is not always an option if you use=20
marks for other purposes.

So, if it is going to be removed from pom-ng I would like to keep it in my=
=20
external pomng-repository.

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1046843135-1185808635=:4354--
