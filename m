From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [ANNOUNCE] Release of libnfnetlink, libnfnetlink_conntrack and
 conntrack
Date: Tue, 18 Oct 2005 13:09:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0510181305080.23072@bizon.gios.gov.pl>
References: <20050924215413.GD731@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.62.0510141219460.3698@bizon.gios.gov.pl>
	<4352E028.7020702@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1040503611-1129633799=:23072"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4352E028.7020702@eurodev.net>
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

---187430788-1040503611-1129633799=:23072
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 17 Oct 2005, Pablo Neira wrote:

> Krzysztof Oledzki wrote:
>> What such errors mean?
>>=20
>> nfnl_parse_attr: deficit (4) len (43200).
>>=20
>> nfnl_parse_attr: deficit (2) len (35072).
>
> This is due to a wrong calculation of the minimum message size. It is
> fixed in SVN.

OK! :) Thank you. When are you going to relase new versions of=20
libnfnetlink/libnfnetlink_conntrack/conntrack?

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1040503611-1129633799=:23072--
