From: Jan Engelhardt <jengelh@medozas.de>
Subject: Xtables-addons 1.5.7 released
Date: Mon, 1 Sep 2008 17:49:25 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809011748160.8643@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



URL:
http://dev.medozas.de/files/xtables/xtables-addons-1.5.7.tar.bz2

Changes from v1.5.5:

James King (1):
      ipset: adjust semaphore.h include for kernel >= 2.6.27

Jan Engelhardt (17):
      build: prepare make tarball for git 1.6.0
      libxt_geoip: reorder option parsing code
      Clear hotdrop before use
      xt_SYSRQ: fix compilation for Linux kernel version <= 2.6.19
      Automatically run `depmod -a`
      fuzzy: import 20050627 code base
      fuzzy: remove unneeded spinlock
      fuzzy: misc cleanup
      fuzzy: IPv6 support
      xt_condition: ues glue-provided init_net__proc_net
      src: move to a pskb-based API
      DHCP address match and mangler
      build: remove dependency on netinet/in6.h
      src: remove redundant return statements
      xt_portscan: IPv6 support
      xt_SYSRQ: add missing aliases
      Xtables-addons 1.5.7


About:
Xtables-addons is a package that mostly supersedes the old patch-o-matic 
repository for the Linux kernel and iptables. Instead of patching the 
kernel source, extensions are built as modules and thus allow extending 
kernels without recompilation.
