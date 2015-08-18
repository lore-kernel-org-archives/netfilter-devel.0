From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v5 1/2] netfilter: nf_conntrack: add direction
 support for zones
Date: Wed, 19 Aug 2015 00:29:18 +0200
Message-ID: <20150818222918.GA17497@salvia>
References: <cover.1439559328.git.daniel@iogearbox.net>
 <d0f84a97f9c86bec4d537536a26d0150873e640d.1439559328.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57850 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbbHRWXJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 18:23:09 -0400
Content-Disposition: inline
In-Reply-To: <d0f84a97f9c86bec4d537536a26d0150873e640d.1439559328.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 14, 2015 at 04:03:39PM +0200, Daniel Borkmann wrote:
> This work adds a direction parameter to netfilter zones, so identity
> separation can be performed only in original/reply or both directions
> (default). This basically opens up the possibility of doing NAT with
> conflicting IP address/port tuples from multiple, isolated tenants
> on a host (e.g. from a netns) without requiring each tenant to NAT
> twice resp. to use its own dedicated IP address to SNAT to, meaning
> overlapping tuples can be made unique with the zone identifier in
> original direction, where the NAT engine will then allocate a unique
> tuple in the commonly shared default zone for the reply direction.
> In some restricted, local DNAT cases, also port redirection could be
> used for making the reply traffic unique w/o requiring SNAT.

Applied, thanks Daniel.
