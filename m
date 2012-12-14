From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 00/11] netfilter: nf_tables: small cleanups and netlink
 fixes
Date: Fri, 14 Dec 2012 08:16:52 +0100
Message-ID: <20121214071652.GA7731@1984>
References: <1355338061-5517-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44166 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab2LNHRB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:17:01 -0500
Content-Disposition: inline
In-Reply-To: <1355338061-5517-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 12, 2012 at 07:47:30PM +0100, kaber@trash.net wrote:
> The following patches clean up a few minor things and fix a couple of netlink
> issues:
> 
> - rename of pid to portid for consistency
> - revert patch to include use attribute only sent by the kernel in nla_policy 
> - move the hgenerator to the table to save a bit memory
> - move the chain policy to basechains
> - send netlink notifications for basechain policy changes
> - introduce a chain handle and fix chain renames
> - fix an invalid event type for rule GET operations
> - remove ability to specify handles for new rules
> - return an error for unsupported rule change requests
> - return an error for rule replacement requests without a rule
> - include NLM_F_APPEND/NLM_F_REPLACE in NEWRULE messages
> 
> Please apply, thanks.

All applied, thanks a lot Patrick.
