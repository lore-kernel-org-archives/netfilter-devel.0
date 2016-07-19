From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 nf] netfilter: x_tables: speed up jump target
 validation
Date: Tue, 19 Jul 2016 20:11:08 +0200
Message-ID: <20160719181108.GA5539@salvia>
References: <1468511486-17283-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56975 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbcGSSLP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jul 2016 14:11:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3D5B6114803
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:11:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2F8E69EBA7
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:11:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 38C85DA8ED
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:11:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468511486-17283-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 14, 2016 at 05:51:26PM +0200, Florian Westphal wrote:
> After this change ruleset restore times get again close to what one
> gets when reverting 36472341017529e (~3 seconds on my workstation).

Applied, thanks.
