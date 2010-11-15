From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] ipvs: remove shadow rt variable
Date: Tue, 16 Nov 2010 07:03:07 +0900
Message-ID: <20101115220307.GC10582@verge.net.au>
References: <1289846793.2607.118.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:46121 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580Ab0KOWDL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:03:11 -0500
Content-Disposition: inline
In-Reply-To: <1289846793.2607.118.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 15, 2010 at 07:46:33PM +0100, Eric Dumazet wrote:
> Remove a sparse warning about rt variable.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks, I'll take this through the lvs-test-2.6 tree.
