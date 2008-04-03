From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 09/24] [NETFILTER]: Implement AF_UNSPEC as a wildcard
 for extensions
Date: Thu, 03 Apr 2008 15:21:26 +0200
Message-ID: <47F4D9D6.6040405@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <0b58dacd5d68bcfe2a9baee271d7d69c6cf66809.1207134547.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34406 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbYDCNVa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:21:30 -0400
In-Reply-To: <0b58dacd5d68bcfe2a9baee271d7d69c6cf66809.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> When a match or target is looked up using xt_find_{match,target},
> Xtables will also search the AF_UNSPEC module list. This allows for
> extensions to be reused from other components (e.g. arptables,
> ebtables).
> 
> Extensions that take different codepaths depending on match->family
> or target->family of course cannot use AF_UNSPEC within the
> registration structure (e.g. xt_pkttype).

I'm skipping this patch until we've sorted out the AF_ARP thing.
