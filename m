From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: fix linking against -lip6tc
Date: Mon, 31 Dec 2012 00:38:28 +0100
Message-ID: <20121230233828.GA30455@1984>
References: <1356909107-9924-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57327 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab2L3Xig (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2012 18:38:36 -0500
Content-Disposition: inline
In-Reply-To: <1356909107-9924-1-git-send-email-vapier@gentoo.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Mike,

On Sun, Dec 30, 2012 at 06:11:47PM -0500, Mike Frysinger wrote:
> The current build forgets to specify a path to find libip6tc which means
> it either fails (if there is no libip6tc in the system), or links against
> an old version (if there is one in the system).

We already got a similar patch fix for that issue:

http://patchwork.ozlabs.org/patch/208133/

Can you give it a try and check if it also fixes the problem for you?

Thanks.
