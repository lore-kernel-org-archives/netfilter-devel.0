From: Ivan Mitev <imitev@obs.bg>
Subject: ipsec patches test: minor compilation and policy match issues
Date: Fri, 16 Apr 2004 00:20:37 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040415212034.GE7611@obs.bg>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hi,

i'm using the CVS (20040415) version of iptables and pom-ng, and kernel
2.6.5, to test the new ipsec patches (ipsec-XX + policy).  
when compiling, iptables seems unhappy about the definition of 2 
includes added by the ipsec-02-input-hooks patch in
include/linux/netfilter_ipv4.h  :

#include <linux/netdevice.h>
#include <net/protocol.h>

with them, the kernel compiles fine, but iptables complains (output
attached). if i comment these 2 includes, iptables compiles cleanly (but then
the kernel fails to compile); see attached iptables compilation output.

another minor problem i had was that, oddly, pom didn't copy the policy
patch's files into the kernel (net/..., include/...), nor did update the
Makefile and Kconfig. 
it copied the iptables files libipt_policy.man and .c, but didn't copy
.policy-test. i didn't try to reproduce this though, so maybe i did 
something wrong. 

anwyway, with the comment/uncomment of the 2 includes, plus with some manual
tweaks for the policy patch, i got everything running.

now, the real testing, so here is the setup (very basic for now): 

all nets are 172.16.x.x/24

               --------                           --------
 .1.0 --- 1.10 | rtr1 | 2.10 --- "inet" ---- 3.10 | rtr2 | 4.10 --- .4.0
          eth0 -------- eth1                 eth1 -------- eth0


rtr1 is the 2.6 ipsec gw where i test the new ipsec patches

"inet" is in fact another router where i can tcpdump to
check that i only have ESP and/or AH packets between 2.10 and 3.10

i only have a tunnel for .1.0 <-> .4.0 networks, and no transport mode.

after a bit of tests, i saw that the ipsec match doesn't work when i specify 
--tunnet-dst/src; otherwise it works very well, at least for this basic setup.

so, for example that rule works:

iptables -A FORWARD -i eth0 -o eth1 -m policy --dir out --pol ipsec --strict --proto esp --mode tunnel -j ACCEPT

while these don't:

iptables -A FORWARD -i eth0 -o eth1 -m policy --dir out --pol ipsec --strict --proto esp --mode tunnel --tunnel-dst 172.16.4.0/24 -j ACCEPT

or

iptables -A FORWARD -i eth0 -o eth1 -m policy --dir out --pol ipsec --strict --proto esp --mode tunnel --tunnel-src 172.16.1.0/24 -j ACCEPT

or 

iptables -A FORWARD -i eth0 -o eth1 -m policy --dir out --pol ipsec --strict --proto esp --mode tunnel --tunnel-src 172.16.1.0/24 --tunnel-dst 172.16.4.0/24 -j ACCEPT


that's it for now; later i'll try to migrate/test a part of a (really) 
more complex setup, with lots of iptables and tc rules (so i expect some 
problems where the packets are seen twice, in their encrypted/de-encrypted 
form). i also have some user-space apps that use ip_queue, so i'll see 
if they'll be broken.

if some of you are interested in more tests for the transport mode, i can
investigate that too...

regards,
ivan

--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=iptables_compilation

Extensions found: IPv4:policy IPv4:recent IPv6:ah IPv6:esp IPv6:frag IPv6:ipv6header IPv6:hbh IPv6:dst IPv6:rt
cc -O2 -Wall -Wunused -I/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2//include -Iinclude/ -DIPTABLES_VERSION=\"1.2.10\"  -fPIC -o extensions/libipt_ah_sh.o -c extensions/libipt_ah.c
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:25:1: warning: "IFNAMSIZ" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:128:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:29:1: warning: "IFF_UP" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:46:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:30:1: warning: "IFF_BROADCAST" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:48:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:31:1: warning: "IFF_DEBUG" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:50:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:32:1: warning: "IFF_LOOPBACK" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:52:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:33:1: warning: "IFF_POINTOPOINT" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:54:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:34:1: warning: "IFF_NOTRAILERS" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:56:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:35:1: warning: "IFF_RUNNING" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:58:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:36:1: warning: "IFF_NOARP" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:60:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:37:1: warning: "IFF_PROMISC" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:62:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:38:1: warning: "IFF_ALLMULTI" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:66:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:40:1: warning: "IFF_MASTER" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:69:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:41:1: warning: "IFF_SLAVE" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:71:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:43:1: warning: "IFF_MULTICAST" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:74:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:47:1: warning: "IFF_PORTSEL" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:77:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:48:1: warning: "IFF_AUTOMEDIA" redefined
In file included from include/libiptc/ipt_kernel_headers.h:14,
                 from include/libiptc/libiptc.h:5,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/usr/include/net/if.h:79:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netdevice.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:10,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:92: error: redefinition of `struct ifmap'
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:128: error: redefinition of `struct ifreq'
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/if.h:178: error: redefinition of `struct ifconf'
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:11,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/in6.h:31: error: redefinition of `struct in6_addr'
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/in6.h:52: error: redefinition of `struct sockaddr_in6'
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/in6.h:60: error: redefinition of `struct ipv6_mreq'
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:11,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/in6.h:129:1: warning: "IPPROTO_HOPOPTS" redefined
In file included from /usr/include/netdb.h:28,
                 from extensions/libipt_ah.c:3:
/usr/include/netinet/in.h:36:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:11,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/in6.h:130:1: warning: "IPPROTO_ROUTING" redefined
In file included from /usr/include/netdb.h:28,
                 from extensions/libipt_ah.c:3:
/usr/include/netinet/in.h:58:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:11,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/in6.h:131:1: warning: "IPPROTO_FRAGMENT" redefined
In file included from /usr/include/netdb.h:28,
                 from extensions/libipt_ah.c:3:
/usr/include/netinet/in.h:60:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:11,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/in6.h:132:1: warning: "IPPROTO_ICMPV6" redefined
In file included from /usr/include/netdb.h:28,
                 from extensions/libipt_ah.c:3:
/usr/include/netinet/in.h:70:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:11,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/in6.h:133:1: warning: "IPPROTO_NONE" redefined
In file included from /usr/include/netdb.h:28,
                 from extensions/libipt_ah.c:3:
/usr/include/netinet/in.h:72:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:11,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/in6.h:134:1: warning: "IPPROTO_DSTOPTS" redefined
In file included from /usr/include/netdb.h:28,
                 from extensions/libipt_ah.c:3:
/usr/include/netinet/in.h:74:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:11,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/in6.h:164:1: warning: "IPV6_ADD_MEMBERSHIP" redefined
In file included from /usr/include/netinet/in.h:253,
                 from /usr/include/netdb.h:28,
                 from extensions/libipt_ah.c:3:
/usr/include/bits/in.h:129:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:28,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:11,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/in6.h:165:1: warning: "IPV6_DROP_MEMBERSHIP" redefined
In file included from /usr/include/netinet/in.h:253,
                 from /usr/include/netdb.h:28,
                 from extensions/libipt_ah.c:3:
/usr/include/bits/in.h:130:1: warning: this is the location of the previous definition
In file included from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4.h:11,
                 from /home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/linux/netfilter_ipv4/ip_tables.h:25,
                 from include/libiptc/libiptc.h:6,
                 from include/iptables.h:5,
                 from extensions/libipt_ah.c:8:
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:39: warning: `struct sk_buff' declared inside parameter list
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:39: warning: its scope is only this definition or declaration, which is probably not what you want
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:40: error: parse error before "u32"
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:40: warning: `struct sk_buff' declared inside parameter list
/home/builds/kernels/build/linux-2.6.5-netfilter-cvs2/include/net/protocol.h:63: error: field `list' has incomplete type
make: *** [extensions/libipt_ah_sh.o] Error 1

--AhhlLboLdkugWU4S--
