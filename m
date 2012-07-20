From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Fix crash when the same NFCT is used by two stacks.
Date: Fri, 20 Jul 2012 10:09:50 +0200
Message-ID: <20120720080950.GB13680@1984>
References: <CAAJpzgYGxVgazp74qck_Diacp7SJCjMOZFhw7cX0_k6B-4Qw9Q@mail.gmail.com>
 <1342680964-1250-1-git-send-email-eric@regit.org>
 <1342680964-1250-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40859 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab2GTIJ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:09:59 -0400
Content-Disposition: inline
In-Reply-To: <1342680964-1250-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 19, 2012 at 08:56:04AM +0200, Eric Leblond wrote:
> The polling timer initialisation code was put in the configurator
> code. It was then created for all instances. But only first one has
> a valid NFCT handle. This was resulting in a crash.
> This patch moves the timer initialisation in the constructor which
> is called only once on the main NFCT instance.

Applied, thanks Eric!
