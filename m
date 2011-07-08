From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack] conntrack: add missing break when parsing --id/--secmark
 options
Date: Fri, 08 Jul 2011 13:31:01 +0200
Message-ID: <4E16EA75.8030307@netfilter.org>
References: <1308173947-3122-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47682 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1GHLbJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jul 2011 07:31:09 -0400
In-Reply-To: <1308173947-3122-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15/06/11 23:39, Florian Westphal wrote:
> commit 147ed522f52a62ab0d854ddc443d27d97dbf6cdf
> (conntrack: add support for mark mask) failed to add a break
> after secmark/id option parsing.
> 
> Results in '-m 42 -c 1' to search for mark 1 instead of 42.

Applied, thanks.
