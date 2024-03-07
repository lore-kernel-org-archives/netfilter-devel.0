Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E229512DD9F;
	Thu,  7 Mar 2024 14:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709820640; cv=none; b=hll+7dAAtUGeJur2kDcJ33E0oA2A+gTVj2jgXOb6clRTopNgIPx2VbBOiXNRH9v6r3Ru/ubPsoS2HS6+kIy0tAFjDqqN3pF95pDDHgmBU2IzMJ80ooEnEgs7qCRzpr6rkA4+gfZGzl74vdvibjEq0cedPGBEK0/UrebpFCa0cZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709820640; c=relaxed/simple;
	bh=IG5hBWgdvIQIXiIi6nwGfY6sqdPdDNVJbUfK9RDSYrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j6p9ZuyOHT7YjgFC5juYCpgCeKq3msB0guDGyEXsI9p5zGmJv4cEVoZ8fDqf6Uc63QRMuP/HiVuSD0YwqLxHg8PW5e3rXAb+5dvr8rIhBEaikVxb6en1K1de4VwmeZhQCAJh9o2g/F9LBJmHOaVLjJchCO4sR4ooVjzmk+vUbCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1riES1-0007l6-Ki; Thu, 07 Mar 2024 15:10:25 +0100
Date: Thu, 7 Mar 2024 15:10:25 +0100
From: Florian Westphal <fw@strlen.de>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, edumazet@google.com,
	pablo@netfilter.org, kadlec@netfilter.org, kuba@kernel.org,
	pabeni@redhat.com, davem@davemloft.net,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
Message-ID: <20240307141025.GL4420@breakpoint.cc>
References: <20240307090732.56708-1-kerneljasonxing@gmail.com>
 <20240307093310.GI4420@breakpoint.cc>
 <CAL+tcoAPi+greENaD8X6Scc97Fnhiqa62eUSn+JS98kqY+VA6A@mail.gmail.com>
 <20240307120054.GK4420@breakpoint.cc>
 <CAL+tcoBqBaHxSU9NQqVxhRzzsaJr4=0=imtyCo4p8+DuXPL5AA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL+tcoBqBaHxSU9NQqVxhRzzsaJr4=0=imtyCo4p8+DuXPL5AA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jason Xing <kerneljasonxing@gmail.com> wrote:
> On Thu, Mar 7, 2024 at 8:00 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > > This change disables most of the tcp_in_window() test, this will
> > > > pretend everything is fine even though tcp_in_window says otherwise.
> > >
> > > Thanks for the information. It does make sense.
> > >
> > > What I've done is quite similar to nf_conntrack_tcp_be_liberal sysctl
> > > knob which you also pointed out. It also pretends to ignore those
> > > out-of-window skbs.
> > >
> > > >
> > > > You could:
> > > >  - drop invalid tcp packets in input hook
> > >
> > > How about changing the return value only as below? Only two cases will
> > > be handled:
> > >
> > > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
> > > b/net/netfilter/nf_conntrack_proto_tcp.c
> > > index ae493599a3ef..c88ce4cd041e 100644
> > > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > > @@ -1259,7 +1259,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
> > >         case NFCT_TCP_INVALID:
> > >                 nf_tcp_handle_invalid(ct, dir, index, skb, state);
> > >                 spin_unlock_bh(&ct->lock);
> > > -               return -NF_ACCEPT;
> > > +               return -NF_DROP;
> >
> > Lets not do this.  conntrack should never drop packets and defer to ruleset
> > whereever possible.
> 
> Hmm, sorry, it is against my understanding.
> 
> If we cannot return -NF_DROP, why have we already added some 'return
> NF_DROP' in the nf_conntrack_handle_packet() function? And why does
> this test statement exist?

Sure we can drop.  But we should only do it if there is no better
alternative.

> nf_conntrack_in()
>   -> nf_conntrack_handle_packet()
>   -> if (ret <= 0) {
>          if (ret == -NF_DROP) NF_CT_STAT_INC_ATOMIC(state->net, drop);

AFAICS this only happens when we receive syn for an existing conntrack
that is being removed already so we'd expect next syn to create a new
connection.  Feel free to send patches that replace drop with -accept
where possible/where it makes sense, but I don't think the
TCP_CONNTRACK_SYN_SENT one can reasonably be avoided.

> My only purpose is not to let the TCP layer sending strange RST to the
> right flow.

AFAIU tcp layer is correct, no?  Out of the blue packet to some listener
socket?

> Besides, resorting to turning on nf_conntrack_tcp_be_liberal sysctl
> knob seems odd to me though it can workaround :S

I don't see a better alternative, other than -p tcp -m conntrack
--ctstate INVALID -j DROP rule, if you wish for tcp stack to not see
such packets.

> I would like to prevent sending such an RST as default behaviour.

I don't see a way to make this work out of the box, without possible
unwanted side effects.

MAYBE we could drop IFF we check that the conntrack entry candidate
that fails sequence validation has NAT translation applied to it, and
thus the '-NF_ACCEPT' packet won't be translated.

Not even compile tested:

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1256,10 +1256,14 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
        case NFCT_TCP_IGNORE:
                spin_unlock_bh(&ct->lock);
                return NF_ACCEPT;
-       case NFCT_TCP_INVALID:
+       case NFCT_TCP_INVALID: {
+               verdict = -NF_ACCEPT;
+               if (ct->status & IPS_NAT_MASK)
+                       res = NF_DROP; /* skb would miss nat transformation */
                nf_tcp_handle_invalid(ct, dir, index, skb, state);
                spin_unlock_bh(&ct->lock);
-               return -NF_ACCEPT;
+               return verdict;
+       }
        case NFCT_TCP_ACCEPT:
                break;
        }

But I don't really see the advantage compared to doing drop decision in
iptables/nftables ruleset.

I also have a hunch that someone will eventually complain about this
change in behavior.
