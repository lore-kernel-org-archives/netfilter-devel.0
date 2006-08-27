From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: Errors trying to build conntrack
Date: Sat, 26 Aug 2006 19:40:37 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206F9D0@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

Hello -=20
=20
This is not my day!  I am trying to build the conntrack utility to help =
me debug some other problems.  First I tried the latest snapshot, =
conntrack-20060826.  But when I unpacked it (tar -xvjf =
conntrack-20060826.tar.bz2) there was no configure script. =20

So I tried beta2, conntrack-1.00beta2.tar.bz2.  This unpacked cleanly =
and the configure script ran to completion without errors.  But make =
blew up.  I will past in the complete output below.

Any idea how to build conntrack or what I am doing wrong?

Thanks

- Greg Scott


[root@lakeville-fw conntrack-1.00beta2]# make
Making all in src
make[1]: Entering directory =
`/home/gregs/conntrack/conntrack-1.00beta2/src'
if gcc -DPACKAGE_NAME=3D\"\" -DPACKAGE_TARNAME=3D\"\" =
-DPACKAGE_VERSION=3D\"\" -DPACKAGE_STRING=3D\"\" =
-DPACKAGE_BUGREPORT=3D\"\" -DPACKAGE=3D\"
conntrack\" -DVERSION=3D\"1.00beta2\" -DSTDC_HEADERS=3D1 =
-DHAVE_SYS_TYPES_H=3D1 -DHAVE_SYS_STAT_H=3D1 -DHAVE_STDLIB_H=3D1 =
-DHAVE_STRING_H=3D1 -D
HAVE_MEMORY_H=3D1 -DHAVE_STRINGS_H=3D1 -DHAVE_INTTYPES_H=3D1 =
-DHAVE_STDINT_H=3D1 -DHAVE_UNISTD_H=3D1 -DHAVE_DLFCN_H=3D1 =
-DHAVE_LIBDL=3D1 -DHAVE_AR
PA_INET_H=3D1 -DHAVE_INET_PTON=3D1 -DHAVE_INET_PTON_IPV6=3D1 -I. -I.  =
-I../include    -g -O2 -DCONNTRACK_LIB_DIR=3D\"/usr/local/lib/conntrac
k/\" -MT conntrack.o -MD -MP -MF ".deps/conntrack.Tpo" \
  -c -o conntrack.o `test -f 'conntrack.c' || echo './'`conntrack.c; \
then mv -f ".deps/conntrack.Tpo" ".deps/conntrack.Po"; \
else rm -f ".deps/conntrack.Tpo"; exit 1; \
fi
In file included from conntrack.c:53:
../include/conntrack.h:6:59: error: =
libnetfilter_conntrack/libnetfilter_conntrack.h: No such file or =
directory
In file included from conntrack.c:53:
../include/conntrack.h:132: error: field =E2protoinfo_attr=E2 has =
incomplete type
../include/conntrack.h:140: warning: =E2union nfct_protoinfo=E2 declared =
inside parameter list
../include/conntrack.h:140: warning: its scope is only this definition =
or declaration, which is probably not what you want
../include/conntrack.h:140: warning: =E2struct nfct_tuple=E2 declared =
inside parameter list
../include/conntrack.h:145: warning: =E2struct nfct_tuple=E2 declared =
inside parameter list
conntrack.c:55:64: error: =
libnetfilter_conntrack/libnetfilter_conntrack_ipv4.h: No such file or =
directory
conntrack.c:56:64: error: =
libnetfilter_conntrack/libnetfilter_conntrack_ipv6.h: No such file or =
directory
conntrack.c:343: error: =E2IPS_ASSURED=E2 undeclared here (not in a =
function)
conntrack.c:343: error: =E2IPS_SEEN_REPLY=E2 undeclared here (not in a =
function)
conntrack.c:344: error: =E2IPS_SRC_NAT_DONE=E2 undeclared here (not in a =
function)
conntrack.c:344: error: =E2IPS_DST_NAT_DONE=E2 undeclared here (not in a =
function)
conntrack.c:346: error: =E2NF_NETLINK_CONNTRACK_NEW=E2 undeclared here =
(not in a function)
conntrack.c:346: error: =E2NF_NETLINK_CONNTRACK_UPDATE=E2 undeclared =
here (not in a function)
conntrack.c:347: error: =E2NF_NETLINK_CONNTRACK_DESTROY=E2 undeclared =
here (not in a function)
conntrack.c:444: warning: =E2union nfct_address=E2 declared inside =
parameter list
conntrack.c: In function =E2parse_inetaddr=E2:
conntrack.c:450: error: dereferencing pointer to incomplete type
conntrack.c:452: error: dereferencing pointer to incomplete type
conntrack.c: At top level:
conntrack.c:459: warning: =E2struct nfct_nat=E2 declared inside =
parameter list
conntrack.c: In function =E2nat_parse=E2:
conntrack.c:486: error: dereferencing pointer to incomplete type
conntrack.c:487: error: dereferencing pointer to incomplete type
conntrack.c:500: error: dereferencing pointer to incomplete type
conntrack.c:501: error: dereferencing pointer to incomplete type
conntrack.c:519: error: dereferencing pointer to incomplete type
conntrack.c:523: error: dereferencing pointer to incomplete type
conntrack.c:525: error: dereferencing pointer to incomplete type
conntrack.c: At top level:
conntrack.c:600: error: =E2NFCT_ANY_ID=E2 undeclared here (not in a =
function)
conntrack.c: In function =E2main=E2:
conntrack.c:676: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:677: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:678: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:679: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:680: error: =E2IPV4_ORIG_SRC=E2 undeclared (first use in =
this function)
conntrack.c:680: error: (Each undeclared identifier is reported only =
once
conntrack.c:680: error: for each function it appears in.)
conntrack.c:681: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:682: error: =E2IPV6_ORIG_SRC=E2 undeclared (first use in =
this function)
conntrack.c:688: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:689: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:690: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:691: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:692: error: =E2IPV4_ORIG_DST=E2 undeclared (first use in =
this function)
conntrack.c:693: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:694: error: =E2IPV6_ORIG_DST=E2 undeclared (first use in =
this function)
conntrack.c:700: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:701: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:702: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:703: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:704: error: =E2IPV4_REPL_SRC=E2 undeclared (first use in =
this function)
conntrack.c:705: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:706: error: =E2IPV6_REPL_SRC=E2 undeclared (first use in =
this function)
conntrack.c:712: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:713: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:714: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:715: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:716: error: =E2IPV4_REPL_DST=E2 undeclared (first use in =
this function)
conntrack.c:717: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:718: error: =E2IPV6_REPL_DST=E2 undeclared (first use in =
this function)
conntrack.c:726: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:727: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:728: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:729: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:756: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:757: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:758: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:764: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:765: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:766: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:772: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:773: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:774: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:780: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:781: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:782: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:788: warning: passing argument 3 of =E2nat_parse=E2 from =
incompatible pointer type
conntrack.c:793: error: =E2NFCT_MARK=E2 undeclared (first use in this =
function)
conntrack.c:822: warning: passing argument 3 of =E2h->parse_opts=E2 from =
incompatible pointer type
conntrack.c:822: warning: passing argument 4 of =E2h->parse_opts=E2 from =
incompatible pointer type
conntrack.c:822: warning: passing argument 5 of =E2h->parse_opts=E2 from =
incompatible pointer type
conntrack.c:822: warning: passing argument 6 of =E2h->parse_opts=E2 from =
incompatible pointer type
conntrack.c:822: warning: passing argument 7 of =E2h->parse_opts=E2 from =
incompatible pointer type
conntrack.c:844: warning: passing argument 3 of =E2h->final_check=E2 =
from incompatible pointer type
conntrack.c:844: warning: passing argument 4 of =E2h->final_check=E2 =
from incompatible pointer type
conntrack.c:853: error: =E2CONNTRACK=E2 undeclared (first use in this =
function)
conntrack.c:853: warning: assignment makes pointer from integer without =
a cast
conntrack.c:865: warning: assignment makes pointer from integer without =
a cast
conntrack.c:869: error: invalid use of undefined type =E2struct =
nfct_conntrack_compare=E2
conntrack.c:870: error: invalid use of undefined type =E2struct =
nfct_conntrack_compare=E2
conntrack.c:871: error: invalid use of undefined type =E2struct =
nfct_conntrack_compare=E2
conntrack.c:872: error: invalid use of undefined type =E2struct =
nfct_conntrack_compare=E2
conntrack.c:878: error: =E2nfct_default_conntrack_display_id=E2 =
undeclared (first use in this function)
conntrack.c:882: error: =E2nfct_default_conntrack_display=E2 undeclared =
(first use in this function)
conntrack.c:894: error: =E2EXPECT=E2 undeclared (first use in this =
function)
conntrack.c:894: warning: assignment makes pointer from integer without =
a cast
conntrack.c:899: error: =E2nfct_default_expect_display_id=E2 undeclared =
(first use in this function)
conntrack.c:903: error: =E2nfct_default_expect_display=E2 undeclared =
(first use in this function)
conntrack.c:912: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:912: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:913: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:913: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:913: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:914: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:914: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:914: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:917: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:917: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:918: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:918: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:918: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:919: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:919: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:919: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:924: warning: assignment makes pointer from integer without =
a cast
conntrack.c:928: warning: assignment makes pointer from integer without =
a cast
conntrack.c:932: warning: assignment makes pointer from integer without =
a cast
conntrack.c:945: warning: assignment makes pointer from integer without =
a cast
conntrack.c:948: warning: assignment makes pointer from integer without =
a cast
conntrack.c:952: warning: assignment makes pointer from integer without =
a cast
conntrack.c:965: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:965: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:966: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:966: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:966: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:967: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:967: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:967: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:970: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:970: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:971: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:971: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:971: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:972: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:972: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:972: error: invalid use of undefined type =E2struct =
nfct_tuple=E2
conntrack.c:976: warning: assignment makes pointer from integer without =
a cast
conntrack.c:980: warning: assignment makes pointer from integer without =
a cast
conntrack.c:994: warning: assignment makes pointer from integer without =
a cast
conntrack.c:999: error: =E2NFCT_DIR_ORIGINAL=E2 undeclared (first use in =
this function)
conntrack.c:1003: error: =E2NFCT_DIR_REPLY=E2 undeclared (first use in =
this function)
conntrack.c:1009: warning: assignment makes pointer from integer without =
a cast
conntrack.c:1020: warning: assignment makes pointer from integer without =
a cast
conntrack.c:1035: warning: assignment makes pointer from integer without =
a cast
conntrack.c:1048: warning: assignment makes pointer from integer without =
a cast
conntrack.c:1056: warning: assignment makes pointer from integer without =
a cast
conntrack.c:1065: warning: assignment makes pointer from integer without =
a cast
conntrack.c:1067: error: =E2NFCT_ALL_CT_GROUPS=E2 undeclared (first use =
in this function)
conntrack.c:1067: warning: assignment makes pointer from integer without =
a cast
conntrack.c:1076: warning: assignment makes pointer from integer without =
a cast
conntrack.c:1080: error: invalid use of undefined type =E2struct =
nfct_conntrack_compare=E2
conntrack.c:1081: error: invalid use of undefined type =E2struct =
nfct_conntrack_compare=E2
conntrack.c:1082: error: invalid use of undefined type =E2struct =
nfct_conntrack_compare=E2
conntrack.c:1083: error: invalid use of undefined type =E2struct =
nfct_conntrack_compare=E2
conntrack.c:1088: error: =E2nfct_default_conntrack_event_display=E2 =
undeclared (first use in this function)
conntrack.c:1095: error: =E2NF_NETLINK_CONNTRACK_EXP_NEW=E2 undeclared =
(first use in this function)
conntrack.c:1095: warning: assignment makes pointer from integer without =
a cast
make[1]: *** [conntrack.o] Error 1
make[1]: Leaving directory =
`/home/gregs/conntrack/conntrack-1.00beta2/src'
make: *** [all-recursive] Error 1
[root@lakeville-fw conntrack-1.00beta2]#=20
