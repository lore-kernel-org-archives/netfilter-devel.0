From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH 1/2] rule: display hook info
Date: Wed, 12 Jun 2013 11:43:11 +0200
Message-ID: <20130612094311.GA4498@localhost>
References: <1370732927-23322-1-git-send-email-eric@regit.org>
 <1370732927-23322-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39562 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3FLJnV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:43:21 -0400
Content-Disposition: inline
In-Reply-To: <1370732927-23322-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 09, 2013 at 01:08:46AM +0200, Eric Leblond wrote:
> It was not possible to restore a ruleset because of missing
> hook information. This patch adds hooknum output to list
> operation.

I have mangled this patch to use a string array instead. I have pushed
it to master.
