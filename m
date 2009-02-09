From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: ctnetlink: allow changing NAT sequence
 adjustment in creation
Date: Mon, 09 Feb 2009 14:26:04 +0100
Message-ID: <49902EEC.3090200@trash.net>
References: <20090127211457.10412.29085.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54646 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZBIN0G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:26:06 -0500
In-Reply-To: <20090127211457.10412.29085.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch fixes an inconsistency in the current ctnetlink code
> since NAT sequence adjustment bit can only be updated but not set
> in the conntrack entry creation.
> 
> This patch is used by conntrackd to successfully recover newly
> created entries that represent connections with helpers and NAT
> payload mangling.

Looks good, applied.
