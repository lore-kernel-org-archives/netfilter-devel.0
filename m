From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ebtables: Fix extension lookup with identical
 name
Date: Wed, 13 Apr 2016 01:17:35 +0200
Message-ID: <20160412231735.GA21103@salvia>
References: <1460417474-8899-1-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37449 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934003AbcDLXRw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 19:17:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1240CC9EEA
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:17:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 026C6AD87
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:17:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 95E0CAD73
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:17:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1460417474-8899-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 12, 2016 at 01:31:14AM +0200, Phil Sutter wrote:
> If a requested extension exists as module and is not loaded,
> ebt_check_match() might accidentally use an NFPROTO_UNSPEC one with same
> name and fail.
> 
> Reproduced with limit match: Given xt_limit and ebt_limit both built as
> module, the following would fail:
> 
>   modprobe xt_limit
>   ebtables -I INPUT --limit 1/s -j ACCEPT
> 
> The fix is to make ebt_check_match() distrust a found NFPROTO_UNSPEC
> extension and retry after requesting an appropriate module.

Applied, thanks.
