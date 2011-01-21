From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 5.4 released
Date: Fri, 21 Jan 2011 23:14:49 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101212302300.10656@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm happy to announce ipset 5.4! Because there are some important kernel 
part fixes in this release, please upgrade. The list of the changes are:

- Kernel part:
  - Fix ICMP and ICMPv6 handling
  - Fix trailing whitespaces and pr_* messages
  - Un-inline functions which are not small enough
  - Fix module loading at create/header commands
  - Fix wrong kzalloc flag in type_pf_expire
  - The get_ip*_port functions are too large to be inlined, moved into the 
    core
  - Add missing __GFP_HIGHMEM flag to __vmalloc
  - Enforce network-ordered data in the netlink protocol
  - Use annotated types and fix sparse warnings
  - Move ip_set_alloc, ip_set_free and ip_set_get_ipaddr* into the core
  - NETMASK*, HOSTMASK* macros are too generic, replace with inline 
    functions
  - Use static LIST_HEAD() for ip_set_type_list
  - Move NLA_PUT_NET* macros to include/net/netlink.h
  - The module parameter max_sets should be unsigned int
  - Get rid of ip_set_kernel.h
  - Fix the placement style of boolean operators at continued lines

Most of the changes are suggested by Patrick in his review, many thanks.

You can download the source code from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

I fixed a bug in the SET target of iptables/ip6tables, which produced 
incorrect output at listing/saving rules with the SET target. The fix is 
available from the git tree or from the daily snapshot 
iptables-20110121.tar.bz2 (or later), or from the next iptables release:

	git://git.netfilter.org/iptables.git
	ftp://ftp.netfilter.org/pub/iptables/snapshot/

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
