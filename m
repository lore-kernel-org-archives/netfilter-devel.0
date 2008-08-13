From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] [PATCH] fix double helper assignation for NAT'ed
 conntracks
Date: Wed, 13 Aug 2008 15:26:38 +0200
Message-ID: <48A2E10E.4000603@trash.net>
References: <20080807100803.8036.8684.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42386 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbYHMN0k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:26:40 -0400
In-Reply-To: <20080807100803.8036.8684.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> If we create a conntrack that has NAT handlings and a helper, the helper
> is assigned twice. This happens because nf_nat_setup_info() - via
> nf_conntrack_alter_reply() - sets the helper before ctnetlink, which
> indeed does not check if the conntrack already has a helper as it thinks that
> it is a brand new conntrack.
> 
> The fix moves the helper assignation before the set of the status flags.
> This avoids a bogus assertion in __nf_ct_ext_add (if netfilter assertions are
> enabled) which checks that the conntrack must not be confirmed.
> 
> This problem was introduced in 2.6.23 with the netfilter extension
> infrastructure.

Applied, thanks.
