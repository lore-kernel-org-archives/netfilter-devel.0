From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nftables: missing set cleanup in do_command_list
Date: Sat, 30 Nov 2013 21:53:35 +0100
Message-ID: <20131130205335.GC8306@localhost>
References: <20131130201551.GA23089@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51272 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3K3Uxj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 15:53:39 -0500
Content-Disposition: inline
In-Reply-To: <20131130201551.GA23089@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 30, 2013 at 12:15:52PM -0800, Phil Oester wrote:
> When listing a table in interactive mode, the set list is not cleaned up.  Thus
> the number of displayed sets grows with each successive listing.  Attached
> patch adds the necessary list cleanup to do_command_list.

Applied, thanks.
