From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Request for maintaining "condition" and "time"
Date: Thu, 12 Jul 2007 00:16:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707120006571.23402@bizon.gios.gov.pl>
References: <13732b70707102143y64c43ea0hb7ba564f41b460c3@mail.gmail.com>
	<Pine.LNX.4.64.0707110912440.11053@fbirervta.pbzchgretzou.qr>
	<13732b70707110029k7d71696dta1fbe1c5128298c@mail.gmail.com>
	<Pine.LNX.4.64.0707110931030.11053@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0707111008390.23402@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-246541533-1184192219=:23402"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707111008390.23402@bizon.gios.gov.pl>
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

---187430788-246541533-1184192219=:23402
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 11 Jul 2007, Krzysztof Oledzki wrote:

>
>
> On Wed, 11 Jul 2007, Jan Engelhardt wrote:
>
>>=20
>> On Jul 11 2007 04:29, Gustavo Jr. Alves wrote:
>>>=20
>>> I=B4m really new on netfilter (this is why I asking so many dumb
>>> questions since yesterday), and I had previously understand that
>>> "time" and "condition" modules has no support at all.
>>=20
>> Well, Krzysztof Oledzki <ole [at] ans.pl> is listed in the pomng db
>> as the maintainer for the time module.
>
> Indeed. I'm going to commit required changes today, I hope. The same for=
=20
> other extensions: IPMARK, connlimit (this would be the last time since=20
> it is going to be included into 2.6.23) and ipp2p.

Committed. Compile test passed. Should work with both 2.6.21 and 2.6.22=20
but there were many changes (especially for 2.6.22) and unfortunately I'm=
=20
not able to test in until tomorrow. So, any feedback is welcome. ;)

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-246541533-1184192219=:23402--
