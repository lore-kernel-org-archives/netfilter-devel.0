From: "Samuel Jean" <sj-netfilter@cookinglinux.org>
Subject: [Fwd: RE: Second Request for help!!]
Date: Mon, 7 Feb 2005 10:52:27 -0500 (EST)
Message-ID: <57143.142.169.215.10.1107791547.squirrel@142.169.215.10>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: jhill@noach.com
To: netfilter-devel@lists.netfilter.org
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

> On Mon, February 7, 2005 9:57 am, John Hill said:
> > Kernel 2.4.29
> > Patch-0-Matic 2005 02 01 patched for fixes and pptp
> > iptables-1.3.0rc1
[...]
> > I have had these errors on all iptables except 1.2.11 and
> pom2040621. I
> > have
> > not been able to update since 6-2004.
[...]
> > Thanks
> >
> > --john
> >

---------------------------- Original Message ---------------------------=
-
Subject: RE: Second Request for help!!
From:    "John Hill" <jhill@noach.com>
Date:    Mon, February 7, 2005 10:28 am
To:      "'Samuel Jean'" <sj-netfilter@cookinglinux.org>
-------------------------------------------------------------------------=
-

I don't have access to post on the developers list.

Here is the whole compile report.
Thanks
--john


Extensions found: IPv4:recent IPv6:ah IPv6:esp IPv6:frag IPv6:ipv6header
IPv6:hbh IPv6:dst IPv6:rt
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_ah_sh.o -c
extensions/libipt_ah.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_ah.so extensions/libipt_ah_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_addrtype_sh=
.o
-c extensions/libipt_addrtype.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_addrtype.c:9:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_addrtype.so
extensions/libipt_addrtype_sh.o cc -O2 -Wall -Wunused
-I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_comment_sh.=
o
-c extensions/libipt_comment.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_comment.c:14:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_comment.so extensions/libipt_comment_sh.=
o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_connlimit_s=
h.o
-c extensions/libipt_connlimit.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_connlimit.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_connlimit.so
extensions/libipt_connlimit_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_connmark_sh=
.o
-c extensions/libipt_connmark.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_connmark.c:28:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_connmark.so
extensions/libipt_connmark_sh.o cc -O2 -Wall -Wunused
-I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_conntrack_s=
h.o
-c extensions/libipt_conntrack.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_conntrack.c:11:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_conntrack.so
extensions/libipt_conntrack_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_dscp_sh.o -=
c
extensions/libipt_dscp.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_dscp.c:20:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
extensions/libipt_dscp_helper.c:69: warning: `dscp_to_name' defined but
not used
ld -shared  -o extensions/libipt_dscp.so extensions/libipt_dscp_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_ecn_sh.o -c
extensions/libipt_ecn.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ecn.c:15:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_ecn.so extensions/libipt_ecn_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_esp_sh.o -c
extensions/libipt_esp.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_esp.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_esp.so extensions/libipt_esp_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_hashlimit_s=
h.o
-c extensions/libipt_hashlimit.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_hashlimit.c:16:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_hashlimit.so
extensions/libipt_hashlimit_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_helper_sh.o=
 -c
extensions/libipt_helper.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_helper.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_helper.so extensions/libipt_helper_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_icmp_sh.o -=
c
extensions/libipt_icmp.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_icmp.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_icmp.so extensions/libipt_icmp_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_iprange_sh.=
o
-c extensions/libipt_iprange.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_iprange.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_iprange.so extensions/libipt_iprange_sh.=
o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_length_sh.o=
 -c
extensions/libipt_length.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_length.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_length.so extensions/libipt_length_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_limit_sh.o =
-c
extensions/libipt_limit.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_limit.c:11:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_limit.so extensions/libipt_limit_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_mac_sh.o -c
extensions/libipt_mac.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_mac.c:12:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_mac.so extensions/libipt_mac_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_mark_sh.o -=
c
extensions/libipt_mark.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_mark.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_mark.so extensions/libipt_mark_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_multiport_s=
h.o
-c extensions/libipt_multiport.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_multiport.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_multiport.so
extensions/libipt_multiport_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_owner_sh.o =
-c
extensions/libipt_owner.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_owner.c:10:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_owner.so extensions/libipt_owner_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_physdev_sh.=
o
-c extensions/libipt_physdev.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_physdev.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_physdev.so extensions/libipt_physdev_sh.=
o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_pkttype_sh.=
o
-c extensions/libipt_pkttype.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_pkttype.c:17:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_pkttype.so extensions/libipt_pkttype_sh.=
o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_realm_sh.o =
-c
extensions/libipt_realm.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_realm.c:12:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_realm.so extensions/libipt_realm_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_rpc_sh.o -c
extensions/libipt_rpc.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_rpc.c:52:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_rpc.so extensions/libipt_rpc_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_sctp_sh.o -=
c
extensions/libipt_sctp.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_sctp.c:17:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_sctp.so extensions/libipt_sctp_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_standard_sh=
.o
-c extensions/libipt_standard.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_standard.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_standard.so
extensions/libipt_standard_sh.o cc -O2 -Wall -Wunused
-I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_state_sh.o =
-c
extensions/libipt_state.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_state.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_state.so extensions/libipt_state_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_tcp_sh.o -c
extensions/libipt_tcp.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_tcp.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_tcp.so extensions/libipt_tcp_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_tcpmss_sh.o=
 -c
extensions/libipt_tcpmss.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_tcpmss.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_tcpmss.so extensions/libipt_tcpmss_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_tos_sh.o -c
extensions/libipt_tos.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_tos.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_tos.so extensions/libipt_tos_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_ttl_sh.o -c
extensions/libipt_ttl.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ttl.c:12:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_ttl.so extensions/libipt_ttl_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_udp_sh.o -c
extensions/libipt_udp.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_udp.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_udp.so extensions/libipt_udp_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_unclean_sh.=
o
-c extensions/libipt_unclean.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_unclean.c:5:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_unclean.so extensions/libipt_unclean_sh.=
o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_CLASSIFY_sh=
.o
-c extensions/libipt_CLASSIFY.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_CLASSIFY.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_CLASSIFY.so
extensions/libipt_CLASSIFY_sh.o cc -O2 -Wall -Wunused
-I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_CONNMARK_sh=
.o
-c extensions/libipt_CONNMARK.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_CONNMARK.c:27:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_CONNMARK.so
extensions/libipt_CONNMARK_sh.o cc -O2 -Wall -Wunused
-I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_DNAT_sh.o -=
c
extensions/libipt_DNAT.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_DNAT.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_DNAT.so extensions/libipt_DNAT_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_DSCP_sh.o -=
c
extensions/libipt_DSCP.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_DSCP.c:17:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
extensions/libipt_dscp_helper.c:69: warning: `dscp_to_name' defined but
not used
ld -shared  -o extensions/libipt_DSCP.so extensions/libipt_DSCP_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_ECN_sh.o -c
extensions/libipt_ECN.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ECN.c:16:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_ECN.so extensions/libipt_ECN_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_LOG_sh.o -c
extensions/libipt_LOG.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_LOG.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_LOG.so extensions/libipt_LOG_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_MARK_sh.o -=
c
extensions/libipt_MARK.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_MARK.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_MARK.so extensions/libipt_MARK_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o
extensions/libipt_MASQUERADE_sh.o -c extensions/libipt_MASQUERADE.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_MASQUERADE.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_MASQUERADE.so
extensions/libipt_MASQUERADE_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_MIRROR_sh.o=
 -c
extensions/libipt_MIRROR.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_MIRROR.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_MIRROR.so extensions/libipt_MIRROR_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_NETMAP_sh.o=
 -c
extensions/libipt_NETMAP.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_NETMAP.c:10:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_NETMAP.so extensions/libipt_NETMAP_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_NOTRACK_sh.=
o
-c extensions/libipt_NOTRACK.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_NOTRACK.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_NOTRACK.so extensions/libipt_NOTRACK_sh.=
o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_REDIRECT_sh=
.o
-c extensions/libipt_REDIRECT.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_REDIRECT.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_REDIRECT.so
extensions/libipt_REDIRECT_sh.o cc -O2 -Wall -Wunused
-I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_REJECT_sh.o=
 -c
extensions/libipt_REJECT.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_REJECT.c:9:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_REJECT.so extensions/libipt_REJECT_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_SAME_sh.o -=
c
extensions/libipt_SAME.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_SAME.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_SAME.so extensions/libipt_SAME_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_SNAT_sh.o -=
c
extensions/libipt_SNAT.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_SNAT.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_SNAT.so extensions/libipt_SNAT_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_TARPIT_sh.o=
 -c
extensions/libipt_TARPIT.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_TARPIT.c:4:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_TARPIT.so extensions/libipt_TARPIT_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_TCPMSS_sh.o=
 -c
extensions/libipt_TCPMSS.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_TCPMSS.c:10:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_TCPMSS.so extensions/libipt_TCPMSS_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_TOS_sh.o -c
extensions/libipt_TOS.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_TOS.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_TOS.so extensions/libipt_TOS_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_TRACE_sh.o =
-c
extensions/libipt_TRACE.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_TRACE.c:7:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_TRACE.so extensions/libipt_TRACE_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_TTL_sh.o -c
extensions/libipt_TTL.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_TTL.c:12:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_TTL.so extensions/libipt_TTL_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_ULOG_sh.o -=
c
extensions/libipt_ULOG.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ULOG.c:18:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_ULOG.so extensions/libipt_ULOG_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libipt_recent_sh.o=
 -c
extensions/libipt_recent.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_recent.c:8:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libipt_recent.so extensions/libipt_recent_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_eui64_sh.o=
 -c
extensions/libip6t_eui64.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_eui64.c:12:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_eui64.so extensions/libip6t_eui64_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_hl_sh.o -c
extensions/libip6t_hl.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_hl.c:13:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_hl.so extensions/libip6t_hl_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_icmpv6_sh.=
o
-c extensions/libip6t_icmpv6.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_icmpv6.c:7:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_icmpv6.so extensions/libip6t_icmpv6_sh.=
o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_length_sh.=
o
-c extensions/libip6t_length.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_length.c:9:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_length.so extensions/libip6t_length_sh.=
o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_limit_sh.o=
 -c
extensions/libip6t_limit.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_limit.c:11:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_limit.so extensions/libip6t_limit_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_mac_sh.o -=
c
extensions/libip6t_mac.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_mac.c:12:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_mac.so extensions/libip6t_mac_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_mark_sh.o =
-c
extensions/libip6t_mark.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_mark.c:8:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_mark.so extensions/libip6t_mark_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o
extensions/libip6t_multiport_sh.o -c extensions/libip6t_multiport.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_multiport.c:7:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_multiport.so
extensions/libip6t_multiport_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_owner_sh.o=
 -c
extensions/libip6t_owner.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_owner.c:10:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_owner.so extensions/libip6t_owner_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_physdev_sh=
.o
-c extensions/libip6t_physdev.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_physdev.c:7:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_physdev.so
extensions/libip6t_physdev_sh.o cc -O2 -Wall -Wunused
-I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_standard_s=
h.o
-c extensions/libip6t_standard.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_standard.c:8:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_standard.so
extensions/libip6t_standard_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_tcp_sh.o -=
c
extensions/libip6t_tcp.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_tcp.c:7:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_tcp.so extensions/libip6t_tcp_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_udp_sh.o -=
c
extensions/libip6t_udp.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_udp.c:7:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_udp.so extensions/libip6t_udp_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_HL_sh.o -c
extensions/libip6t_HL.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_HL.c:12:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_HL.so extensions/libip6t_HL_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_LOG_sh.o -=
c
extensions/libip6t_LOG.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_LOG.c:8:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_LOG.so extensions/libip6t_LOG_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_MARK_sh.o =
-c
extensions/libip6t_MARK.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_MARK.c:7:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_MARK.so extensions/libip6t_MARK_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_TRACE_sh.o=
 -c
extensions/libip6t_TRACE.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_TRACE.c:7:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_TRACE.so extensions/libip6t_TRACE_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_ah_sh.o -c
extensions/libip6t_ah.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_ah.c:8:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_ah.so extensions/libip6t_ah_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_esp_sh.o -=
c
extensions/libip6t_esp.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_esp.c:8:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_esp.so extensions/libip6t_esp_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_frag_sh.o =
-c
extensions/libip6t_frag.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_frag.c:8:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_frag.so extensions/libip6t_frag_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o
extensions/libip6t_ipv6header_sh.o -c extensions/libip6t_ipv6header.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_ipv6header.c:8:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_ipv6header.so
extensions/libip6t_ipv6header_sh.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_hbh_sh.o -=
c
extensions/libip6t_hbh.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_hbh.c:8:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_hbh.so extensions/libip6t_hbh_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_dst_sh.o -=
c
extensions/libip6t_dst.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_dst.c:8:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_dst.so extensions/libip6t_dst_sh.o cc
-O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -fPIC -o extensions/libip6t_rt_sh.o -c
extensions/libip6t_rt.c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from extensions/libip6t_rt.c:8:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
ld -shared  -o extensions/libip6t_rt.so extensions/libip6t_rt_sh.o cc -O2
-Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -DIPT_LIB_DIR=3D\"/usr/local/lib/iptab=
les\"
-c -o iptables.o iptables.c
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from iptables.c:39:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"    -c -o libiptc/libip4tc.o
libiptc/libip4tc.c
In file included from include/libiptc/libiptc.h:6,
                 from libiptc/libip4tc.c:29:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
libiptc/libip4tc.c:128: warning: `dump_entry' defined but not used ar rv
libiptc/libiptc.a libiptc/libip4tc.o
a - libiptc/libip4tc.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"    -c -o libiptc/libip6tc.o
libiptc/libip6tc.c
In file included from include/libiptc/libip6tc.h:6,
                 from libiptc/libip6tc.c:30:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
libiptc/libip6tc.c:133: warning: `dump_entry' defined but not used ar rv
libiptc/libiptc.a libiptc/libip6tc.o
a - libiptc/libip6tc.o
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -DIPT_LIB_DIR=3D\"/usr/local/lib/iptab=
les\"
-rdynamic -o iptables iptables-standalone.c iptables.o libiptc/libiptc.a
-ldl -lnsl
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from iptables-standalone.c:38:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
sed -e '/@MATCH@/ r extensions/libipt_matches.man' -e '/@TARGET@/ r
extensions/libipt_targets.man' iptables.8.in >iptables.8
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -DIPT_LIB_DIR=3D\"/usr/local/lib/iptab=
les\"
-rdynamic -o iptables-save iptables-save.c iptables.o libiptc/libiptc.a
-ldl -lnsl
In file included from include/libiptc/libiptc.h:6,
                 from iptables-save.c:17:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"  -DIPT_LIB_DIR=3D\"/usr/local/lib/iptab=
les\"
-rdynamic -o iptables-restore iptables-restore.c iptables.o
libiptc/libiptc.a -ldl -lnsl
In file included from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from iptables-restore.c:15:
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: typ=
e
defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
`DECLARE_MUTEX' declared `static' but never defined
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"=20
-DIP6T_LIB_DIR=3D\"/usr/local/lib/iptables\" -c -o ip6tables.o ip6tables.=
c
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from ip6tables.c:38:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"=20
-DIP6T_LIB_DIR=3D\"/usr/local/lib/iptables\" -rdynamic -o ip6tables
ip6tables-standalone.c ip6tables.o libiptc/libiptc.a -ldl -lnsl
In file included from include/libiptc/libip6tc.h:6,
                 from include/ip6tables.h:5,
                 from ip6tables-standalone.c:37:
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
type defaults to `int' in declaration of `DECLARE_MUTEX'
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
parameter names (without types) in function declaration
/usr/src/linux/include/linux/netfilter_ipv6/ip6_tables.h:109: warning:
`DECLARE_MUTEX' declared `static' but never defined
sed -e '/@MATCH@/ r extensions/libip6t_matches.man' -e '/@TARGET@/ r
extensions/libip6t_targets.man' ip6tables.8.in >ip6tables.8
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=3D\"1.3.0rc1\"    -c -o libipq/libipq.o libipq/libipq.=
c
ar rv libipq/libipq.a libipq/libipq.o
a - libipq/libipq.o
rm libipq/libipq.o libiptc/libip4tc.o libiptc/libip6tc.o
root@firewall:/usr/src/iptables#
