From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: trouble building iptables-1.2.7a in 2.4.17
Date: Fri, 20 Dec 2002 00:59:44 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200212200859.gBK8xiR08854@isis.cs3-inc.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


transcript follows
I do see, e.g., IP_CT_DIR_MAX declared in 
/home/user/linux-2.4.17/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
but that seems to be only #ifdef __KERNEL__

It looks like this is corrected in
patch-o-matic-20020825/submitted/2.4.18.patch but I'm in .17 and
iptables-1.2.7a claims to require 2.4.4 + so should build here, right?

====

[root@router2 /root]# cd iptables-1.2.7a/
[root@router2 iptables-1.2.7a]# make KERNEL_DIR=/home/user/linux-2.4.17
Making dependencies: please wait...
Extensions found:
cc -O2 -Wall -Wunused -I/home/user/linux-2.4.17/include -Iinclude/ -DIPTABLES_VERSION=\"1.2.7a\"  -fPIC -o extensions/libipt_ah_sh.o -c extensions/libipt_ah.c
ld -shared -o extensions/libipt_ah.so extensions/libipt_ah_sh.o
cc -O2 -Wall -Wunused -I/home/user/linux-2.4.17/include -Iinclude/ -DIPTABLES_VERSION=\"1.2.7a\"  -fPIC -o extensions/libipt_conntrack_sh.o -c extensions/libipt_conntrack.c
In file included from extensions/libipt_conntrack.c:15:
include/linux/netfilter_ipv4/ipt_conntrack.h:28: `IP_CT_DIR_MAX' undeclared here (not in a function)
include/linux/netfilter_ipv4/ipt_conntrack.h:29: `IP_CT_DIR_MAX' undeclared here (not in a function)
include/linux/netfilter_ipv4/ipt_conntrack.h:29: `IP_CT_DIR_MAX' undeclared here (not in a function)
extensions/libipt_conntrack.c: In function `parse_status':
extensions/libipt_conntrack.c:103: `IPS_EXPECTED' undeclared (first use in this function)
extensions/libipt_conntrack.c:103: (Each undeclared identifier is reported only once
extensions/libipt_conntrack.c:103: for each function it appears in.)
extensions/libipt_conntrack.c:105: `IPS_SEEN_REPLY' undeclared (first use in this function)
extensions/libipt_conntrack.c:107: `IPS_ASSURED' undeclared (first use in this function)
extensions/libipt_conntrack.c: In function `parse':
extensions/libipt_conntrack.c:202: `IP_CT_DIR_ORIGINAL' undeclared (first use in this function)
extensions/libipt_conntrack.c:259: `IP_CT_DIR_REPLY' undeclared (first use in this function)
extensions/libipt_conntrack.c: In function `print_status':
extensions/libipt_conntrack.c:364: `IPS_EXPECTED' undeclared (first use in this function)
extensions/libipt_conntrack.c:368: `IPS_SEEN_REPLY' undeclared (first use in this function)
extensions/libipt_conntrack.c:372: `IPS_ASSURED' undeclared (first use in this function)
extensions/libipt_conntrack.c: In function `matchinfo_print':
extensions/libipt_conntrack.c:420: `IP_CT_DIR_ORIGINAL' undeclared (first use in this function)
extensions/libipt_conntrack.c:440: `IP_CT_DIR_REPLY' undeclared (first use in this function)
make: *** [extensions/libipt_conntrack_sh.o] Error 1
