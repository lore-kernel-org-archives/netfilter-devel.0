From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3] netfilter: nf_tables: cleanup and a bugfix
Date: Sun, 30 Mar 2014 13:35:31 +0200
Message-ID: <20140330113531.GB5895@localhost>
References: <1396089783-3984-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43017 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbaC3Lfk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2014 07:35:40 -0400
Content-Disposition: inline
In-Reply-To: <1396089783-3984-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 29, 2014 at 10:43:00AM +0000, Patrick McHardy wrote:
> These patches contain some cleanup and preparation for variable sized data.
> To support variable sized data, we need the length of each key for validation
> of the register load. Move the key validation back into the init functions
> of meta/ct to do this. This also qualifies as a cleanup in my opinion, the
> split is quite unnatural and the code is easier to read by handling get and
> set operations seperately.
> 
> Additionally a patch to add a missing ifdef for NFT_CT_MARK is included.

Applied, thanks Patrick.
