From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Request for maintaining "condition" and "time"
Date: Wed, 11 Jul 2007 10:19:42 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707111008390.23402@bizon.gios.gov.pl>
References: <13732b70707102143y64c43ea0hb7ba564f41b460c3@mail.gmail.com>
	<Pine.LNX.4.64.0707110912440.11053@fbirervta.pbzchgretzou.qr>
	<13732b70707110029k7d71696dta1fbe1c5128298c@mail.gmail.com>
	<Pine.LNX.4.64.0707110931030.11053@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1173676172-1184141982=:23402"
Cc: netfilter-devel@lists.netfilter.org
To: Jan Engelhardt <jengelh@computergmbh.de>,
	"Gustavo Jr. Alves" <gjalves@gjalves.com.br>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707110931030.11053@fbirervta.pbzchgretzou.qr>
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

---187430788-1173676172-1184141982=:23402
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 11 Jul 2007, Jan Engelhardt wrote:

>
> On Jul 11 2007 04:29, Gustavo Jr. Alves wrote:
>>
>> I=B4m really new on netfilter (this is why I asking so many dumb
>> questions since yesterday), and I had previously understand that
>> "time" and "condition" modules has no support at all.
>
> Well, Krzysztof Oledzki <ole [at] ans.pl> is listed in the pomng db
> as the maintainer for the time module.

Indeed. I'm going to commit required changes today, I hope. The same for=20
other extensions: MARK, connlimit (this would be the last time since it is=
=20
going to be included into 2.6.23) and ipp2p.

So, thank you for patches and of course if someone want's to take and=20
rewrite specific extension (like it was done with connlimit) I have no=20
objection for that.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1173676172-1184141982=:23402--
