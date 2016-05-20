From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_conntrack PATCH v2 1/3] src: add support for IPv6
 to struct __nfct_nat
Date: Fri, 20 May 2016 11:34:39 +0200
Message-ID: <20160520093439.GA2028@salvia>
References: <146356174434.15746.15408366557914731507.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60305 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686AbcETJew (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2016 05:34:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2B4D8C9EC3
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:34:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 16F2311CF2C
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:34:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 07B97120337
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:34:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146356174434.15746.15408366557914731507.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 18, 2016 at 10:56:19AM +0200, Arturo Borrero Gonzalez wrote:
> The conntrackd daemon lacks support for syncing IPv6 NATed connections.
> 
> This patch prepares the ground to give support to such operations:
>  * replace uint32_t with union __nfct_address in struct __nfct_nat.
>  * update all users of the former uint32_t to support the new struct
> 
> A follow-up patch gives support to actually manage the IPv6 NAT.

$ git am
/tmp/libnetfilter_conntrack-v2-1-3-src-add-support-for-IPv6-to-struct-__nfct_nat.patch
Applying: src: add support for IPv6 to struct __nfct_nat
error: patch failed: src/conntrack/setter.c:237
error: src/conntrack/setter.c: patch does not apply
Patch failed at 0001 src: add support for IPv6 to struct __nfct_nat
The copy of the patch that failed is found in:
   /home/pablo/devel/scm/git-netfilter/libnetfilter_conntrack/.git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am
--abort".

This doesn't apply cleanly, please rebase on top of git HEAD and resubmit.

Thanks.
