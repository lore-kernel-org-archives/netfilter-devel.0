From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Xtables, Xtables-addons 1.5.2
Date: Tue, 4 Mar 2008 16:51:05 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58831 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320AbYCDPvH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:51:07 -0500
In-Reply-To: <47CD6296.90303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 4 2008 15:54, Patrick McHardy wrote:
>
> It would be a lot better if you would post your patches
> instead publishing your own versions of iptables.
>

Give me a break, I was about to do that, just had some
ordering issues :-) (aka how-do-I-sort-this-now)

iptables/Xtables:
	git://dev.computergmbh.de/xtables-dev master
	Range: 55ad85c12405b61b8c3c082888c75d1559a93c1e(^)..
		b567100706830bb8917220d81350edc6623e8189
	Response follows in subthread.

Jan Engelhardt (24):
      Update .gitignore
      Fix compilation of iptables-static build
      Correct the family member value of libxt_mark rev.1
      Makefile: add a "tarball" target
      Drop -W from CFLAGS and some tiny code cleanups
      Fix -Wshadow warnings and clean up xt_sctp.h.
      Fix all remaining warnings (missing declarations, missing prototypes)
      Add support for xt_hashlimit match revision 1
      Update the libxt_owner manpage with the UID/GID-range feature
      Combine IP{,6}T_LIB_DIR into XTABLES_LIBDIR
      Move libipt_recent to libxt_recent
      Add IPv6 support to libxt_recent
      Add all necessary header files - compilation fix for various cases
      Update package name (Xtables) and documentation
      configure: split --enable-libipq from --enable-devel
      Install libiptc header files because xtables.h depends on it
      Remove support for compilation of conditional extensions
      Combine ipt and ip6t manpages
      Implement AF_UNSPEC as a wildcard for extensions
      Change IPTABLES_VERSION to XTABLES_VERSION
      Update spelling and grammar in manpages
      Fix broken markup in manpages
      Clarify prerequisites of Xtables and update option notes
      Xtables 1.5.2

---

linux:
	git://dev.computergmbh.de/linux master
	Range: c95858194ffe1fbe19fa99287c78c10046bb188b(^)..
		ba5aecde37b53f3c3853943f33c7def80bca3e38
	Response follows in subthread.

Jan Engelhardt (19):
      [NETFILTER]: xt_sctp: simplify xt_sctp.h
      [NETFILTER]: annotate xtables targets with const and remove casts
      [NETFILTER]: annotate {arp,ip,ip6,x}tables with const
      [NETFILTER]: annotate rest of nf_conntrack_* with const
      [NETFILTER]: annotate rest of nf_nat_* with const
      [NETFILTER]: Use unsigned types for hooknum and pf vars
      [NETFILTER]: remove arpt_table indirection macro
      [NETFILTER]: remove arpt_target indirection macro
      [NETFILTER]: remove ARPT_{STANDARD,ERROR}_TARGET indirection macro
      [NETFILTER]: remove unused ARPT_ALIGN indirection macros
      [NETFILTER]: remove arpt_(un)register_target indirection macros
      [NETFILTER]: remove ARPT_{CONTINUE,RETURN} indirection macros
      [NETFILTER]: remove ARPT_{CONTINUE,RETURN} indirection macros
      [NETFILTER]: rename NF_ARP to AF_ARP and assign a non-clashing value
      [NETFILTER]: Implement AF_UNSPEC as a wildcard for extensions
      [NETFILTER]: Explicitly initialize .priority in arptable_filter
      [NETFILTER]: Give AF-independent extensions an arpt_ alias
      [NETFILTER]: Rename ipt_recent to xt_recent
      [NETFILTER]: xt_recent: IPv6 support
