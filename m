From: =?UTF-8?B?UMSTdGVyaXMgS8S8YXZpxYbFoQ==?= <klavins@netspace.net.au>
Subject: [RFC] netfilter: Rename ipt_ECN.h to ipt_ecn_target.h (and similar)
 to avoid file name clash
Date: Sat, 16 Aug 2008 00:03:23 +0200
Message-ID: <g84ufs$l66$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42076 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYHPJaI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 05:30:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KUI6k-0000d2-Lc
	for netfilter-devel@vger.kernel.org; Sat, 16 Aug 2008 09:30:02 +0000
Received: from 217-133-15-180.b2b.tiscali.it ([217.133.15.180])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Aug 2008 09:30:02 +0000
Received: from klavins by 217-133-15-180.b2b.tiscali.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Aug 2008 09:30:02 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a request for comments on the proposal that the following 
filename changes (indicative at this point) be made in the netfilter 
source code tree, together with correcting the corresponding references 
to the files in both source code, the build system, and wherever else 
necessary.

The changes are proposed in order to avoid file name clashes on 
filesystems that do not allow two files to have names that differ only 
in the case of their letters:

include/linux/netfilter/xt_CONNMARK.h => xt_connmark_target.h
include/linux/netfilter/xt_DSCP.h => xt_dscp_target.h
include/linux/netfilter/xt_MARK.h => xt_mark_target.h
include/linux/netfilter/xt_RATEEST.h => xt_rateest_target.h
include/linux/netfilter/xt_TCPMSS.h => xt_tcpmss_target.h
include/linux/netfilter_ipv4/ipt_CONNMARK.h => ipt_connmark_target.h
include/linux/netfilter_ipv4/ipt_DSCP.h => ipt_dscp_target.h
include/linux/netfilter_ipv4/ipt_ECN.h => ipt_ecn_target.h
include/linux/netfilter_ipv4/ipt_MARK.h => ipt_mark_target.h
include/linux/netfilter_ipv4/ipt_TCPMSS.h => ipt_tcpmss_target.h
include/linux/netfilter_ipv4/ipt_TOS.h => ipt_tos_target.h
include/linux/netfilter_ipv4/ipt_TTL.h => ipt_ttl_target.h
include/linux/netfilter_ipv6/ip6t_HL.h => ip6t_hl_target.h
include/linux/netfilter_ipv6/ip6t_MARK.h => ip6t_mark_target.h
net/ipv4/netfilter/ipt_ECN.c => ipt_ecn_target.c
net/ipv4/netfilter/ipt_TTL.c => ipt_ttl_target.c
net/ipv6/netfilter/ip6t_HL.c => ip6t_hl_target.c
net/netfilter/xt_CONNMARK.c => xt_connmark_target.c
net/netfilter/xt_DSCP.c => xt_dscp_target.c
net/netfilter/xt_MARK.c => xt_mark_target.c
net/netfilter/xt_RATEEST.c => xt_rateest_target.c
net/netfilter/xt_TCPMSS.c => xt_tcpmss_target.c

This has been discussed before on the git mailing list (see thread 
http://article.gmane.org/gmane.comp.version-control.git/38612 ), and I 
believe it to be a problem that will start to crop up more often than 
not, given the proliferation of open source code onto a variety of 
platforms that have this type of filename intolerance.

The reason for posting to this list is to hear your considered opinion 
on the impact of these proposed file name changes on the netfilter and 
linux kernel development communities.  If you prefer I submit complete 
patches before discussion, I could try to do that.

-- 
  Peter Klavins

