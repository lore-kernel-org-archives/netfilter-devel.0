From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3] netfilter: nf_tables fixes
Date: Thu, 5 Mar 2015 21:23:33 +0100
Message-ID: <20150305202333.GA3997@salvia>
References: <1425413060-6187-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60084 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbbCEUTz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 15:19:55 -0500
Content-Disposition: inline
In-Reply-To: <1425413060-6187-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 03, 2015 at 08:04:17PM +0000, Patrick McHardy wrote:
> I'm starting to push over my nftables set patches, as a first
> batch these three patches fix some bugs I noticed in the process:
> 
> * a race condition in the transaction code
> * a possible rule dlen overflow
> * a possible userdata ulen overflow

Applied, thanks a lot Patrick.
