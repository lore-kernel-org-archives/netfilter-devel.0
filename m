From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nftables: add 'delete map' syntax
Date: Sat, 30 Nov 2013 21:54:03 +0100
Message-ID: <20131130205403.GD8306@localhost>
References: <20131130204121.GA23143@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51298 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab3K3UyI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 15:54:08 -0500
Content-Disposition: inline
In-Reply-To: <20131130204121.GA23143@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 30, 2013 at 12:41:21PM -0800, Phil Oester wrote:
> Creating a map is done via "add map".  However, to delete a map requires using
> "delete set", which is confusing.  Add the appropriate synonym to parser.  
> The downside to this is that one can now delete a set with "delete map", but
> this seems a minor issue.  It could of course be fixed by adding a new
> CMD_OBJ_MAP.
> 
> This closes netfilter bugzilla #879.

Applied this fix as well. Thanks.
