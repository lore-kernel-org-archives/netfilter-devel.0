From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [00/29] Netfilter patches
Date: Tue, 25 Mar 2008 19:03:04 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0803251900470.31276@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52520 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbYCYSDG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:03:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This mail serves as a graft point for git-send-email (let's hope it 
works).

Jan Engelhardt (29):
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
       [NETFILTER]: Rename ipt_recent to xt_recent
       [NETFILTER]: xt_recent: IPv6 support
       [NETFILTER]: nf_nat: autoload IPv4 connection tracking
       [NETFILTER]: Use bool in nf_conntrack_l4proto
       [NETFILTER]: Use bool in nf_conntrack_l3proto
       [NETFILTER]: nf_conntrack_sctp: const annotations
       [NETFILTER]: Use bool in nf_conntrack_tuple.h
       [NETFILTER]: Replace anon union by nf_conntrack_man_proto
       [NETFILTER]: Give AF-independent extensions an arpt_ alias
       [NETFILTER]: Make Ebtables use Xtables infrastructure
       [NETFILTER]: Deploy a prefix_length-to-network mask mapping table
       [NETFILTER]: xt_length match, revision 1
       [NETFILTER]: Replace NF_CT_DUMP_TUPLE macro indrection by function call

