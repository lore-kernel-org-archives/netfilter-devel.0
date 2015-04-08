From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: x_tables: don't extract flow keys on
 early demuxed sks in socket match
Date: Wed, 8 Apr 2015 18:58:45 +0200
Message-ID: <20150408165845.GA3827@salvia>
References: <11bd4dd88cf6bf5a91b70ef80185c4778fa41364.1427972980.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47418 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbbDHQym (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 12:54:42 -0400
Content-Disposition: inline
In-Reply-To: <11bd4dd88cf6bf5a91b70ef80185c4778fa41364.1427972980.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 02, 2015 at 02:28:30PM +0200, Daniel Borkmann wrote:
> Currently in xt_socket, we take advantage of early demuxed sockets
> since commit 00028aa37098 ("netfilter: xt_socket: use IP early demux")
> in order to avoid a second socket lookup in the fast path, but we
> only make partial use of this:
> 
> We still unnecessarily parse headers, extract proto, {s,d}addr and
> {s,d}ports from the skb data, accessing possible conntrack information,
> etc even though we were not even calling into the socket lookup via
> xt_socket_get_sock_{v4,v6}() due to skb->sk hit, meaning those cycles
> can be spared.
> 
> After this patch, we only proceed the slower, manual lookup path
> when we have a skb->sk miss, thus time to match verdict for early
> demuxed sockets will improve further, which might be i.e. interesting
> for use cases such as mentioned in 681f130f39e1 ("netfilter: xt_socket:
> add XT_SOCKET_NOWILDCARD flag").

Applied, thanks.
