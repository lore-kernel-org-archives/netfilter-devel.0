From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netns nf_conntrack: elegantly simplify nf_ct_exp_net()
Date: Fri, 12 Feb 2010 06:25:15 +0100
Message-ID: <4B74E63B.9000607@trash.net>
References: <20100211194041.GA7515@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56844 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0BLFZS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Feb 2010 00:25:18 -0500
In-Reply-To: <20100211194041.GA7515@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Remove #ifdef at nf_ct_exp_net() by using nf_ct_net().

Applied, thanks.
