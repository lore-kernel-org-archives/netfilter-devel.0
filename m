From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: reset nf_trace in nf_reset
Date: Mon, 25 Mar 2013 20:31:46 +0100
Message-ID: <20130325193146.GA3351@localhost>
References: <1363931322-2286-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50379 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758364Ab3CYTb4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Mar 2013 15:31:56 -0400
Content-Disposition: inline
In-Reply-To: <1363931322-2286-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 22, 2013 at 01:48:41PM +0800, Gao feng wrote:
> We forgot to clear the nf_trace of sk_buff in nf_reset,
> When we use veth device, this nf_trace information will
> be leaked from one net namespace to another net namespace.

Applied to the nf tree, thanks Gao.
