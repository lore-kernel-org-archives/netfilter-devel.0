From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: nf_ct_tcp: fix flow recovery with TCP
 window	tracking enabled
Date: Thu, 15 Jul 2010 11:16:37 +0200
Message-ID: <4C3ED1F5.3050400@trash.net>
References: <20100712165241.4026.83949.stgit@decadence> <20100712165953.4026.90708.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39969 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab0GOJQj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:16:39 -0400
In-Reply-To: <20100712165953.4026.90708.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 12.07.2010 18:59, schrieb Pablo Neira Ayuso:
> This patch adds the missing bits to support the recovery of TCP flows
> without disabling window tracking (aka be_liberal). To ensure a
> successful recovery, we have to inject the window scale factor via
> ctnetlink.
> 
> This patch has been tested with a development snapshot of conntrackd
> and the new clause `TCPWindowTracking' that allows to perform strict
> TCP window tracking recovery across fail-overs.
> 
> With this patch, we don't update the receiver's window until it's not
> initiated. We require this to perform a successful recovery. Jozsef
> confirmed in a private email that this spotted a real issue since that
> should not happen.

Regarding the question whether to put this into nf-2.6.git or
nf-next.git, does this fix any bugs besides adding support for
using window tracking with synchronization? I'm not quite sure
what "a real issue" is supposed to mean in this case.
