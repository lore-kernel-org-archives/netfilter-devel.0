From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: "local_bh_disable" [net/ipv4/netfilter/ip_conntrack_pptp.ko]
	undefined!
Date: Wed, 11 Jan 2006 10:49:12 +0100
Message-ID: <BAY103-F14AC8393B0461DA69156BCB2240@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

I'm compiling pptp conntrack/nat as module and I getting this warning:

make modules output:

  CC [M]  net/ipv4/netfilter/ip_conntrack_helper_pptp.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_proto_gre.o
net/ipv4/netfilter/ip_conntrack_proto_gre.c: In function 
`gre_keymap_lookup':
net/ipv4/netfilter/ip_conntrack_proto_gre.c:84: warning: implicit 
declaration of function `local_bh_disable'
net/ipv4/netfilter/ip_conntrack_proto_gre.c:89: warning: implicit 
declaration of function `local_bh_enable'
  CC [M]  net/ipv4/netfilter/ip_nat_helper_pptp.o
  CC [M]  net/ipv4/netfilter/ip_nat_proto_gre.o
  LD [M]  net/ipv4/netfilter/ip_conntrack_pptp.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_tftp.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_ftp.o
  LD [M]  net/ipv4/netfilter/ip_nat_pptp.o
  CC [M]  net/ipv4/netfilter/ip_nat_tftp.o
  CC [M]  net/ipv4/netfilter/ip_nat_ftp.o
[...]
  CC [M]  lib/libcrc32c.o
  Building modules, stage 2.
  MODPOST
*** Warning: "local_bh_disable" [net/ipv4/netfilter/ip_conntrack_pptp.ko] 
undefined!
  CC      drivers/block/floppy.mod.o

Linux is 2.6.15-git7 compiled on Slackware 10.2 (gcc 3.3.6 glibc 2.3.5)
