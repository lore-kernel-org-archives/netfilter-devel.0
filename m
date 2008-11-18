From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: ctnetlink: helper modules load-on-demand
 support
Date: Tue, 18 Nov 2008 11:54:49 +0100
Message-ID: <49229EF9.4030402@trash.net>
References: <20081118030948.28549.30226.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33694 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbYKRKyz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 05:54:55 -0500
In-Reply-To: <20081118030948.28549.30226.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds module loading for helpers via ctnetlink.
> 
> * Creation path: We support explicit and implicit helper assignation. For
>   the explicit case, we try to load the module. If the module is correctly
>   loaded and the helper is present, we return EAGAIN to re-start the
>   creation. Otherwise, we return EOPNOTSUPP.
> * Update path: release the spin lock, load the module and check. If it is
>   present, then return EAGAIN to re-start the update.
> 
> This patch provides a refactorized function to lookup-and-set the
> connection tracking helper. The function removes the exported symbol
> __nf_ct_helper_find as it has not clients anymore.

Applied, thanks Pablo.
