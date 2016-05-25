From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink_delinerize: don't use meta_match_postprocess
 for ct pp
Date: Wed, 25 May 2016 10:36:55 +0200
Message-ID: <20160525083655.GA3842@salvia>
References: <1464091369-4230-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43932 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbcEYIhD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2016 04:37:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B6B061C4388
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 10:36:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A456415D621
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 10:36:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A852B100A72
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 10:36:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464091369-4230-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 24, 2016 at 02:02:49PM +0200, Florian Westphal wrote:
> meta_match_postprocess uses meta.base which is only accessible if
> left expression has EXPR_META type, so we can't use it to handle ct postprocessing.
> 
> To reduce copy-pastry factor the common part into ct_meta_common_postprocess(),
> then call that from both meta and ct postprocessing.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
