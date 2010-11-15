From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: fix the wrong alloc_size
Date: Mon, 15 Nov 2010 11:48:24 +0100
Message-ID: <4CE10FF8.2040505@trash.net>
References: <1289716548-30767-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62061 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab0KOKsW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:48:22 -0500
In-Reply-To: <1289716548-30767-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.11.2010 07:35, Changli Gao wrote:
> In function update_alloc_size(), sizeof(struct nf_ct_ext) is added twice
> wrongly.

Nice catch, applied.
