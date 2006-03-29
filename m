From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] patch-o-matic-ng snap 20060329 some fix
Date: Wed, 29 Mar 2006 18:36:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603291814400.1705@bizon.gios.gov.pl>
References: <442AAEDC.2080107@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-420654142-1143650184=:1705"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-2?Q?=22Wojciech_=5C=22Sas=5C=22_Ci=EAciwa=22?=
	<cieciwa@alpha.zarz.agh.edu.pl>
In-Reply-To: <442AAEDC.2080107@alpha.zarz.agh.edu.pl>
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

---187430788-420654142-1143650184=:1705
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 29 Mar 2006, "Wojciech \"Sas\" Ci=EAciwa" wrote:

> I try to add this snap to kernel 2.6.16.1, and got 3 error in module:
> fuzzy, nth and random.
>
> In attachment ane patches, pleas check and applay if this is correct.

The fuzzy extension does not work:
unable to find ladd slot in src /tmp/pom-1272/net/ipv6/netfilter/Makefile (=
=2E/patchlets/fuzzy/linux-2.6.10/./net/ipv6/netfilter/Makefile.ladd)

The problem is that the ip6t_mac.o is no longer in in=20
net/ipv6/netfilter/Makefile as it was converted to the x_tables.

It would be grate if you also fix the warnings:
   CC      net/ipv4/netfilter/ipt_nth.o
net/ipv4/netfilter/ipt_nth.c:144: warning: initialization from incompatible=
 pointer type
net/ipv4/netfilter/ipt_nth.c:145: warning: initialization from incompatible=
 pointer type

   CC      net/ipv6/netfilter/ip6t_nth.o
net/ipv6/netfilter/ip6t_nth.c:145: warning: initialization from incompatibl=
e pointer type

   CC      net/ipv6/netfilter/ip6t_random.o
net/ipv6/netfilter/ip6t_random.c:75: warning: initialization from incompati=
ble pointer type

Finally you may also consider cleaning patched extensions from files for=20
old 2.6 kernels and keep only patchlets/*/linux-2.6 directories.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-420654142-1143650184=:1705--
