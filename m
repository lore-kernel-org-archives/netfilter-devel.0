From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft: fix endianness in dump function
Date: Thu, 12 Dec 2013 09:41:44 +0100
Message-ID: <20131212084144.GA5135@localhost>
References: <1386834719-29204-1-git-send-email-eric@regit.org>
 <1386834719-29204-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40116 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab3LLIlz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:41:55 -0500
Content-Disposition: inline
In-Reply-To: <1386834719-29204-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 12, 2013 at 08:51:59AM +0100, Eric Leblond wrote:
> The dump function in nft_reject_ipv4 was not converting a u32
> field to network order before sending it to userspace.

Good catch. I've been reviewing other but I haven't seen any similar
endianess issue.

Applied to the nf tree, thanks Eric.
