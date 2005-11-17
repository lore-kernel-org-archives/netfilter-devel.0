From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Re[2]: how to install time patch
Date: Thu, 17 Nov 2005 14:19:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511171416150.20297@bizon.gios.gov.pl>
References: <20051117110729.16390.qmail@web53604.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1357899937-1132233572=:20297"
Cc: netfilter-devel@lists.netfilter.org, Markus Stubbe <mail@epfi.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: manish popli <popli_manish77@yahoo.com>
In-Reply-To: <20051117110729.16390.qmail@web53604.mail.yahoo.com>
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

---187430788-1357899937-1132233572=:20297
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 17 Nov 2005, manish popli wrote:

> I am fail to install time patch for iptables..
> i have visited at
> http://www.lowth.com/howto/add-iptables-modules.php
>
> but i m not able to doit successful..can any one guide
> me how to install "libipt_time.so" under Enterprise
> linux AS-3 (Linux version 2.4.21-4.ELsmp)..

Hm... To use -m time you need to have ip_time enabled kernel. This=20
2.4.21-4.ELsmp smeems to be very old, I don't remember if it has=20
/proc/net/ip_tables_matches interface, is so please try:

grep '^time$' /proc/net/ip_tables_matches|wc -l

BTW, any chances for upgrading kernel?

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1357899937-1132233572=:20297--
