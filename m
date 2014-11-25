From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 1/2 nf] Revert "netfilter: conntrack: fix race in
 __nf_conntrack_confirm against get_next_corpse"
Date: Tue, 25 Nov 2014 13:26:29 +0100
Message-ID: <20141125132629.28448018@redhat.com>
References: <1416870887-5285-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, dborkman@redhat.com,
	jp.pozzi@izzop.net, programme110@gmail.com, brouer@redhat.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbaKYM0k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:26:40 -0500
In-Reply-To: <1416870887-5285-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 25 Nov 2014 00:14:46 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> This reverts commit 5195c14c8b27cc0b18220ddbf0e5ad3328a04187.
> 
> If the conntrack clashes with an existing one, it is left out of
> the unconfirmed, thus, crashing when dropping the packet and
> releasing the conntrack.
> 
> Reported-by: Daniel Borkmann <dborkman@redhat.com>
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=88841
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> I prefer to revert the original fix and replace it by the follow up to
> pass one single patch to -stable.

I'm fine with the revert.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
