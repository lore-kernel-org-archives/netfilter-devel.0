From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] net: nft: call ipv6_find_hdr() with explicitly
 initialized offset
Date: Fri, 20 Dec 2013 11:26:30 +0100
Message-ID: <20131220102630.GA16971@localhost>
References: <1387534995-28883-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36722 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369Ab3LTK0f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:26:35 -0500
Content-Disposition: inline
In-Reply-To: <1387534995-28883-1-git-send-email-dborkman@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 20, 2013 at 11:23:15AM +0100, Daniel Borkmann wrote:
> In nft's nft_exthdr_eval() routine we process IPv6 extension header
> through invoking ipv6_find_hdr(), but we call it with an uninitialized
> offset variable that contains some stack value. In ipv6_find_hdr()
> we then test if the value of offset != 0 and call skb_header_pointer()
> on that offset in order to map struct ipv6hdr into it. Fix it up by
> initializing offset to 0 as it was probably intended to be.

good catch, applied. Thanks Daniel.
