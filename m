From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Question about iphash and nethash
Date: Sun, 9 Jul 2006 18:01:58 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607091748110.25841@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1046022190-1152460918=:25841"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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

---187430788-1046022190-1152460918=:25841
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

I noticed that in my firewalls I very often need to use both iphash and=20
nethash when I need to match set of addresses, because such lists contains=
=20
both /32 hosts and, for example, /24 networks. This requires additional=20
number of rules - 2x or even 4x when I need to match both src and dst.=20
What is the reason that it is not possible to use /32 on nethash? I may=20
guess that iphash is probably faster than nethash so maybe a possiblity to=
=20
match a lists of setnames (eg: -m set --set set1,set2 src) is better?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1046022190-1152460918=:25841--
