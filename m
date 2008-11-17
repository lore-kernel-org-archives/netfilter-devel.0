From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/8] [PATCH] connection tracking helper name persistent
 aliases
Date: Mon, 17 Nov 2008 16:02:19 +0100
Message-ID: <4921877B.2040204@trash.net>
References: <20081117083924.11368.38741.stgit@Decadence> <20081117084033.11368.90083.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45780 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYKQPCY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:02:24 -0500
In-Reply-To: <20081117084033.11368.90083.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds the macro MODULE_ALIAS_NFCT_HELPER that defines a
> way to provide generic and persistent aliases for the connection
> tracking helpers.
> 
> This next patch requires this patch.

Applied, thanks.
