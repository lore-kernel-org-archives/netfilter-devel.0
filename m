From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH iptables] configure: Fix assignment statement
Date: Thu, 23 Jun 2016 08:23:01 +0200
Message-ID: <20160623062301.GB23098@breakpoint.cc>
References: <1466624499-10503-1-git-send-email-shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35530 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbcFWGXH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 02:23:07 -0400
Content-Disposition: inline
In-Reply-To: <1466624499-10503-1-git-send-email-shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> The assignment statement was interpreted as executing enable_connlabel
> command with the argument "no". This was due to the whitespaces in the
> assignment.
> 
> Fixes the trivial bug introduced in commit 3b7a227 (configure: Show
> support for connlabel)

Applied, thanks for following up on this.
