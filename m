From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 1/3] netfilter: nf_conntrack: push zone object into
 functions
Date: Tue, 11 Aug 2015 12:49:10 +0200
Message-ID: <20150811104910.GA4283@salvia>
References: <cover.1439059434.git.daniel@iogearbox.net>
 <c66ea4b9eef6c21dbd4ac186ac0e8792f3de0b0f.1439059435.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41490 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964822AbbHKKny (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Aug 2015 06:43:54 -0400
Content-Disposition: inline
In-Reply-To: <c66ea4b9eef6c21dbd4ac186ac0e8792f3de0b0f.1439059435.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 08, 2015 at 09:40:01PM +0200, Daniel Borkmann wrote:
> This patch replaces the zone id which is pushed down into functions
> with the actual zone object. It's a bigger one-time change, but
> needed for later on extending zones with a direction parameter, and
> thus decoupling this additional information from all call-sites.
> 
> No functional changes in this patch.
> 
> The default zone becomes a global const object, namely nf_ct_zone_dflt
> and will be returned directly in various cases, one being, when there's
> f.e. no zoning support.

Applied, thanks Daniel.
