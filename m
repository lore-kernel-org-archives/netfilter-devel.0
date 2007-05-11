From: husnu demir <hdemir@metu.edu.tr>
Subject: RE: Compile errors for debian-amd64
Date: Fri, 11 May 2007 11:21:46 +0300
Message-ID: <20070511082145.GA2289804@metu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi,

I am trying to compile kernel 2.6.21.1 with ipset from pom-ng snapshot of 10.05.2007. However, there is problem as;


Kernel: arch/x86_64/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 725 modules
WARNING: "ip6t_register_target" [net/ipv6/netfilter/ip6t_ROUTE.ko] undefined!
WARNING: "ip6t_unregister_target" [net/ipv6/netfilter/ip6t_ROUTE.ko] undefined!
WARNING: "ipt_register_match" [net/ipv4/netfilter/ipt_set.ko] undefined!
WARNING: "ipt_unregister_match" [net/ipv4/netfilter/ipt_set.ko] undefined!
WARNING: "ipt_register_target" [net/ipv4/netfilter/ipt_SET.ko] undefined!
WARNING: "ipt_unregister_target" [net/ipv4/netfilter/ipt_SET.ko] undefined!
WARNING: "ipt_register_target" [net/ipv4/netfilter/ipt_ROUTE.ko] undefined!
WARNING: "ipt_unregister_target" [net/ipv4/netfilter/ipt_ROUTE.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


When I change the ipt_unregister_match(&set_match); to xt_reg... etc., it compiles but does not work. I think it needs something elses.

# iptables -A OUTPUT -m set --set izinli src -j ACCEPT
iptables: No chain/target/match by that name


# ipset -nL izinli
Name: izinli
Type: iphash
References: 0
Default binding: 
Header: hashsize: 1024 probes: 8 resize: 50
Members:
10.10.144.156
Bindings:



Do I only need help on this subject? I could not find any patches available on the dev-list and also for the ROUTE as said before??


Thanks.

hdemir.
