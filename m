From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v3 1/3] netfilter: nf_conntrack: push zone object
 into functions
Date: Thu, 30 Jul 2015 18:07:44 +0200
Message-ID: <20150730160744.GA15008@salvia>
References: <cover.1437561897.git.daniel@iogearbox.net>
 <2f95183cf2520b93d8443be935372fbef3499b96.1437561897.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39045 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbbG3QB7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2015 12:01:59 -0400
Content-Disposition: inline
In-Reply-To: <2f95183cf2520b93d8443be935372fbef3499b96.1437561897.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 22, 2015 at 12:54:46PM +0200, Daniel Borkmann wrote:
> This patch replaces the zone id which is pushed down into functions
> with the actual zone object. It's a bigger one-time change, but
> needed for later on extending zones with a direction parameter, and
> thus decoupling this additional information from all call-sites.
> 
> No functional changes in this patch.
> 
> The default zones becomes a global const object, namely nf_ct_zone_dflt
> and will be returned directly in various cases, one being, when there's
> f.e. no zoning support.

Looks fine. This patchset depends on the recent fixes though, so let
me send a pull request to David with pending nf-next updates, then you
can rebase upon a fresh HEAD.

Regarding follow up patches, it would be good if you rename CTA_DIR to
CTA_ZONE_DIR. If you plan to place more information into the zone
extension, then it's probably a good idea to add a new nested
CTA_ZONE_INFO attribute where we can start adding new more information
on the zone configuration there that applies to the tuple.

I have seen also that you placed zone-dir= after use= in the sysctl
output, but you can place this after the zone instead. We have a
netlink interface so people should not be doing string parsing.

I'll make a closer look later to see if I have more comments. Thanks
for your patience, Daniel.
