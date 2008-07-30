From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/7] use nf_conntrack_get instead of atomic_inc
Date: Wed, 30 Jul 2008 15:25:18 +0200
Message-ID: <48906BBE.1010803@trash.net>
References: <48904A75.90905@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48125 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYG3NZV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:25:21 -0400
In-Reply-To: <48904A75.90905@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> [PATCH] use nf_conntrack_get instead of atomic_inc
> 
> Use nf_conntrack_get instead of the direct call to atomic_inc.

Applied, thanks.
