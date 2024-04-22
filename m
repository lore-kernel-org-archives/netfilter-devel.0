Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8DA818132A;
	Mon, 22 Apr 2024 22:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713826550; cv=none; b=oLMT6rTgmxguSqreRl7z9Voc7bvjwEuNDPj8LDhJoanZG+rGZBpWrpronUY7o5ryWmdhWOic0NsL+VDuvtl98/2diRCbA0AlyWWWnfdsy8/9GvY2n1PyVsIDsrOpOgw5sbyh50VhapX5O5RmjAB0d/boHAcX6YGAM53712uXClE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713826550; c=relaxed/simple;
	bh=Tl/IFuwo9x59Am6aE4v1PqVIE7YsgqE8d8g+aBwQCzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXFkmd8BjoqeCalR9vnx7RdPqXJ0x5VtmhxUGzQ0hyK8OiTUcMNBct1llth10j2m6E2M3FjhgiKK0wo3ZRPhIkrHDJyruD6mYB+EHoukQ/2OxwmSOf9zfnHdO4rsiH9U3IW0jCW5/2/T90COqL6tVJBSOUreVf0IU0TkucpMUFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 23 Apr 2024 00:55:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 4/4] netfilter: nfnetlink: Handle ACK flags
 for batch messages
Message-ID: <Zibq6Z4Vhhe_Ggip@calendula>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
 <20240418104737.77914-5-donald.hunter@gmail.com>
 <ZiFKvyvojcIqMQ3R@calendula>
 <m2a5lpha4m.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m2a5lpha4m.fsf@gmail.com>

On Fri, Apr 19, 2024 at 12:20:25PM +0100, Donald Hunter wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
> > Hi Donald,
> >
> > Apologies for a bit late jumping back on this, it took me a while.
> >
> > On Thu, Apr 18, 2024 at 11:47:37AM +0100, Donald Hunter wrote:
> >> The NLM_F_ACK flag is ignored for nfnetlink batch begin and end
> >> messages. This is a problem for ynl which wants to receive an ack for
> >> every message it sends, not just the commands in between the begin/end
> >> messages.
> >
> > Just a side note: Turning on NLM_F_ACK for every message fills up the
> > receiver buffer very quickly, leading to ENOBUFS. Netlink, in general,
> > supports batching (with non-atomic semantics), I did not look at ynl
> > in detail, if it does send() + recv() for each message for other
> > subsystem then fine, but if it uses batching to amortize the cost of
> > the syscall then this explicit ACK could be an issue with very large
> > batches.
> 
> ynl is batching the messages for send() and will accept batches from
> recv() but nfnetlink is sending each ack separately.

Yes, like it happens with other existing netlink interfaces when
batching is used, nfnetlink is no different in such case.

> It is using netlink_ack() which uses a new skb for each message, for
> example:
> 
> sudo strace -e sendto,recvfrom ./tools/net/ynl/cli.py \
>      --spec Documentation/netlink/specs/nftables.yaml \
>      --multi batch-begin '{"res-id": 10}' \
>      --multi newtable '{"name": "test", "nfgen-family": 1}' \
>      --multi newchain '{"name": "chain", "table": "test", "nfgen-family": 1}' \
>      --multi batch-end '{"res-id": 10}'
> sendto(3, [[{nlmsg_len=20, nlmsg_type=0x10 /* NLMSG_??? */, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28254, nlmsg_pid=0}, "\x00\x00\x00\x0a"], [{nlmsg_len=32, nlmsg_type=0xa00 /* NLMSG_??? */, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28255, nlmsg_pid=0}, "\x01\x00\x00\x00\x09\x00\x01\x00\x74\x65\x73\x74\x00\x00\x00\x00"], [{nlmsg_len=44, nlmsg_type=0xa03 /* NLMSG_??? */, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28256, nlmsg_pid=0}, "\x01\x00\x00\x00\x0a\x00\x03\x00\x63\x68\x61\x69\x6e\x00\x00\x00\x09\x00\x01\x00\x74\x65\x73\x74\x00\x00\x00\x00"], [{nlmsg_len=20, nlmsg_type=0x11 /* NLMSG_??? */, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28257, nlmsg_pid=0}, "\x00\x00\x00\x0a"]], 116, 0, NULL, 0) = 116
> recvfrom(3, [{nlmsg_len=36, nlmsg_type=NLMSG_ERROR, nlmsg_flags=NLM_F_CAPPED, nlmsg_seq=28254, nlmsg_pid=997}, {error=0, msg={nlmsg_len=20, nlmsg_type=NFNL_MSG_BATCH_BEGIN, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28254, nlmsg_pid=0}}], 131072, 0, NULL, NULL) = 36
> recvfrom(3, [{nlmsg_len=36, nlmsg_type=NLMSG_ERROR, nlmsg_flags=NLM_F_CAPPED, nlmsg_seq=28255, nlmsg_pid=997}, {error=0, msg={nlmsg_len=32, nlmsg_type=NFNL_SUBSYS_NFTABLES<<8|NFT_MSG_NEWTABLE, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28255, nlmsg_pid=0}}], 131072, 0, NULL, NULL) = 36
> recvfrom(3, [{nlmsg_len=36, nlmsg_type=NLMSG_ERROR, nlmsg_flags=NLM_F_CAPPED, nlmsg_seq=28256, nlmsg_pid=997}, {error=0, msg={nlmsg_len=44, nlmsg_type=NFNL_SUBSYS_NFTABLES<<8|NFT_MSG_NEWCHAIN, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28256, nlmsg_pid=0}}], 131072, 0, NULL, NULL) = 36
> recvfrom(3, [{nlmsg_len=36, nlmsg_type=NLMSG_ERROR, nlmsg_flags=NLM_F_CAPPED, nlmsg_seq=28257, nlmsg_pid=997}, {error=0, msg={nlmsg_len=20, nlmsg_type=NFNL_MSG_BATCH_END, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28257, nlmsg_pid=0}}], 131072, 0, NULL, NULL) = 36
> 
> > Out of curiosity: Why does the tool need an explicit ack for each
> > command? As mentioned above, this consumes a lot netlink bandwidth.
> 
> For the ynl python library, I guess it was a design choice to request an
> ack for each command.
> 
> Since the Netlink API allows a user to request acks, it seems necessary
> to be consistent about providing them. Otherwise we'd need to extend the
> netlink message specs to say which messages are ack capable and which
> are not.

I see.

> >> Add processing for ACKs for begin/end messages and provide responses
> >> when requested.
> >> 
> >> I have checked that iproute2, pyroute2 and systemd are unaffected by
> >> this change since none of them use NLM_F_ACK for batch begin/end.
> >
> > nitpick: Quick grep shows me iproute2 does not use the nfnetlink
> > subsystem? If I am correct, maybe remove this.
> 
> Yeah, my mistake. I did check iproute2 but didn't mean to add it to the
> list. For nft, NFNL_MSG_BATCH_* usage is contained in libnftnl from what
> I can see. I'll update the patch.
> 
> > Thanks!
> >
> > One more comment below.
> 
> Did you miss adding a comment?

No more comments, thanks.
