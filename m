From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-translate: Printing the table name before chain
 name
Date: Thu, 7 Apr 2016 11:50:23 +0200
Message-ID: <20160407095023.GA2959@salvia>
References: <20160405070837.GA12017@inbhdhcp21574.apac.nsn-net.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guruswamy Basavaiah <guru2018@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51102 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbcDGJua (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 05:50:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9684480B17
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:50:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7DDCFDA3AC
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:50:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 82B58DA3AA
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:50:24 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160405070837.GA12017@inbhdhcp21574.apac.nsn-net.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 05, 2016 at 12:38:37PM +0530, Guruswamy Basavaiah wrote:
> Printing the table name before chain name.
> 
> Command ./iptables-restore-translate, was printing
> table name before the chain name for user added chains.
> This is breaking ./nft -f command.
> 
> Before fix, output of "./iptables-restore-translate"
> add chain ip OUTPUT_direct raw
> 
> After fix:
> add chain ip raw OUTPUT_direct

I want to take this fix, but it doesn't apply:

$ git am /tmp/iptables-translate-Printing-the-table-name-before-chain-name.patch -s
Applying: iptables-translate: Printing the table name before chain name
error: patch failed: iptables/xtables-translate.c:296
error: iptables/xtables-translate.c: patch does not apply
Patch failed at 0001 iptables-translate: Printing the table name before chain name
The copy of the patch that failed is found in:
   /home/pablo/devel/scm/git-netfilter/iptables/.git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

