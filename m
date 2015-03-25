From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: nft_meta: use raw_smp_processor_id()
Date: Wed, 25 Mar 2015 12:20:17 +0100
Message-ID: <20150325112017.GB6553@salvia>
References: <1427270996-6311-1-git-send-email-kaber@trash.net>
 <1427270996-6311-2-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51603 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbbCYLQT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 07:16:19 -0400
Content-Disposition: inline
In-Reply-To: <1427270996-6311-2-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 25, 2015 at 08:09:56AM +0000, Patrick McHardy wrote:
> Using smp_processor_id() triggers warnings with PREEMPT_RCU. There is no
> point in disabling preemption since we only collect the numeric value,
> so use raw_smp_processor_id() instead.

Also applied, thanks.
