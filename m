From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: init all_locks to avoid debug
 warning
Date: Fri, 29 Apr 2016 11:23:07 +0200
Message-ID: <20160429092307.GA13111@salvia>
References: <1461453434-4271-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57868 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbcD2JXN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 05:23:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3FB52C9EC4
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:23:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2F274100A57
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:23:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EA413D1D81
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:23:08 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1461453434-4271-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 24, 2016 at 01:17:14AM +0200, Florian Westphal wrote:
> Else we get 'BUG: spinlock bad magic on CPU#' on resize when
> spin lock debugging is enabled.

Applied, thanks Florian.
