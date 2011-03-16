From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ebtables: Fix xt_AUDIT to work with ebtables, return
 EBT_CONTINUE if NFPROTO_BRIDGE
Date: Wed, 16 Mar 2011 18:33:56 +0100
Message-ID: <4D80F484.4000508@trash.net>
References: <20110316003307.GB26145@canuck.infradead.org> <alpine.LNX.2.01.1103160138160.1189@obet.zrqbmnf.qr> <20110316092032.GA10096@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35540 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1CPRd6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:33:58 -0400
In-Reply-To: <20110316092032.GA10096@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.03.2011 10:20, Thomas Graf wrote:
> Even though ebtables uses xtables it still requires targets to
> return EBT_CONTINUE instead of XT_CONTINUE. This prevented
> xt_AUDIT to work as ebt module.
> 
> Upon Jan's suggestion, use a separate struct xt_target for
> NFPROTO_BRIDGE having its own target callback returning
> EBT_CONTINUE instead of cloning the module.
> 

Applied, thanks Thomas.
