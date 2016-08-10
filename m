From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/4, V3, libnftnl] Implement rule comparison
Date: Wed, 10 Aug 2016 13:35:56 +0200
Message-ID: <20160810113556.GA8891@salvia>
References: <20160808144834.GB6264@salvia>
 <20160810094857.14227-1-carlosfg@riseup.net>
 <20160810094857.14227-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56254 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S941054AbcHJTFB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:05:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2FA181878A9
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 13:36:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 20AEFFF12D
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 13:36:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 08EB3A8E9
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 13:35:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160810094857.14227-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 11:48:55AM +0200, Carlos Falgueras García wrote:
> This patch implements the function 'bool nftnl_rule_cmp(const struct
> nftnl_rule *r, const struct nftnl_rule *r2)' for rule comparison.
> 
> Expressions within rules need to be compared, so also has been created the
> function 'nftnl_expr_cmp' which calls new field within
> 'nfntl_expr_<expression>': a function pointer to a comparator. The
> expressions that can be compared with memcmp have this new field set to
> NULL, otherwise they have implemented a comparator.

Could you send me a follow up patch to extend what we have under
tests/ so it covers these new nftnl_.*_cmp() functions? I would like
to have this tested before applying this.

Thanks!
