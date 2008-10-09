From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] [PATCH] connection tracking helper name persistent
 aliases
Date: Thu, 09 Oct 2008 15:27:24 +0200
Message-ID: <48EE06BC.5080900@trash.net>
References: <20081009083339.9824.24056.stgit@Decadence> <20081009083400.9824.65794.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51192 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428AbYJIN10 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:27:26 -0400
In-Reply-To: <20081009083400.9824.65794.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds the macro MODULE_ALIAS_NFCT_HELPER that defines a
> way to provide generic and persistent aliases for the connection
> tracking helpers.
> 
> This next patch requires this patch.

Applied, thanks.
