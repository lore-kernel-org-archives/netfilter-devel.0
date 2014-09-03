From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] src: Add devgroup support in meta expresion.
Date: Wed, 3 Sep 2014 14:22:02 +0200
Message-ID: <20140903122202.GA18744@salvia>
References: <1409683037-11611-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55047 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaICMVf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:21:35 -0400
Content-Disposition: inline
In-Reply-To: <1409683037-11611-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 02, 2014 at 08:37:17PM +0200, Ana Rey wrote:
> This adds device group support in meta expresion.
> 
> The new attributes of meta are "iffgroup" and "oifgroup"
> - iffgroup: Match device group of incoming device.
> - oifgroup: Match device group of outcoming device.
> 
> Example of use:
> nft add rule ip test input meta iifgroup 2 counter
> nft add rule ip test output meta oifgroup 2 counter
> 
> The kernel and libnftnl support were added in these commits:
> netfilter: nf_tables: add devgroup support in meta expresion
> src: meta: Add devgroup support to meta expresion

Applied, thanks.

