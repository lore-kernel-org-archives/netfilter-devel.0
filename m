Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3FD20B27;
	Fri, 22 Mar 2024 10:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711104060; cv=none; b=b9ofB5MDgMwNQucSvFIoGOJLL3DBVioSXDtK8Duje9S55KEtAj9EFoW0+URosaTAy2M3+M4jOS+pqCkk8vzgI8rDxuHxVwQ1P1TmBcJ/khX/O/zK1TXBaMNGbQmYmJXDnwedIITz+snPuvoy0XKCY1R8HIILhT3FallIm/tTH2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711104060; c=relaxed/simple;
	bh=WNbm9BKeW+52olRaQ9fXdh9kaGSnI0KyIBBLfetg+NM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dL4kEy57I/d0LrBrU511lYvUzIE5Qmi82JNwGQgs7viIR3OqdgiWqEJGeN04Qwk24wqufQXXwqOrlblAlfP1giVuoneZ65HxhYQ1xRMrajxEajECJlMZD0in7IyutrWhgIL50FyPOSaZYC3Ya1NsiiMYPt78aW+2Yk2iSNgEbAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Fri, 22 Mar 2024 11:40:52 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: edumazet@google.com, kadlec@netfilter.org, fw@strlen.de,
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
Message-ID: <Zf1gNAt3gprnQPjb@calendula>
References: <20240311070550.7438-1-kerneljasonxing@gmail.com>
 <ZfyhR_24HmShs78t@calendula>
 <CAL+tcoBHU7RKWvDkDVK+8poXK_XdNU0sskwuY6R-B0oatmDOxg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL+tcoBHU7RKWvDkDVK+8poXK_XdNU0sskwuY6R-B0oatmDOxg@mail.gmail.com>

On Fri, Mar 22, 2024 at 09:06:41AM +0800, Jason Xing wrote:
> Hello Pablo,
> 
> On Fri, Mar 22, 2024 at 5:06 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Mon, Mar 11, 2024 at 03:05:50PM +0800, Jason Xing wrote:
> > > From: Jason Xing <kernelxing@tencent.com>
> > >
> > > Supposing we set DNAT policy converting a_port to b_port on the
> > > server at the beginning, the socket is set up by using 4-tuple:
> > >
> > > client_ip:client_port <--> server_ip:b_port
> > >
> > > Then, some strange skbs from client or gateway, say, out-of-window
> > > skbs are eventually sent to the server_ip:a_port (not b_port)
> > > in TCP layer due to netfilter clearing skb->_nfct value in
> > > nf_conntrack_in() function. Why? Because the tcp_in_window()
> > > considers the incoming skb as an invalid skb by returning
> > > NFCT_TCP_INVALID.
> > >
> > > At last, the TCP layer process the out-of-window
> > > skb (client_ip,client_port,server_ip,a_port) and try to look up
> > > such an socket in tcp_v4_rcv(), as we can see, it will fail for sure
> > > because the port is a_port not our expected b_port and then send
> > > back an RST to the client.
> > >
> > > The detailed call graphs go like this:
> > > 1)
> > > nf_conntrack_in()
> > >   -> nf_conntrack_handle_packet()
> > >     -> nf_conntrack_tcp_packet()
> > >       -> tcp_in_window() // tests if the skb is out-of-window
> > >       -> return -NF_ACCEPT;
> > >   -> skb->_nfct = 0; // if the above line returns a negative value
> > > 2)
> > > tcp_v4_rcv()
> > >   -> __inet_lookup_skb() // fails, then jump to no_tcp_socket
> > >   -> tcp_v4_send_reset()
> > >
> > > The moment the client receives the RST, it will drop. So the RST
> > > skb doesn't hurt the client (maybe hurt some gateway which cancels
> > > the session when filtering the RST without validating
> > > the sequence because of performance reason). Well, it doesn't
> > > matter. However, we can see many strange RST in flight.
> > >
> > > The key reason why I wrote this patch is that I don't think
> > > the behaviour is expected because the RFC 793 defines this
> > > case:
> > >
> > > "If the connection is in a synchronized state (ESTABLISHED,
> > >  FIN-WAIT-1, FIN-WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT),
> > >  any unacceptable segment (out of window sequence number or
> > >  unacceptible acknowledgment number) must elicit only an empty
> > >  acknowledgment segment containing the current send-sequence number
> > >  and an acknowledgment..."
> > >
> > > I think, even we have set DNAT policy, it would be better if the
> > > whole process/behaviour adheres to the original TCP behaviour as
> > > default.
> > >
> > > Suggested-by: Florian Westphal <fw@strlen.de>
> > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > ---
> > > v2
> > > Link: https://lore.kernel.org/netdev/20240307090732.56708-1-kerneljasonxing@gmail.com/
> > > 1. add one more test about NAT and then drop the skb (Florian)
> > > ---
> > >  net/netfilter/nf_conntrack_proto_tcp.c | 15 +++++++++++++--
> > >  1 file changed, 13 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> > > index ae493599a3ef..19ddac526ea0 100644
> > > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > > @@ -1256,10 +1256,21 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
> > >       case NFCT_TCP_IGNORE:
> > >               spin_unlock_bh(&ct->lock);
> > >               return NF_ACCEPT;
> > > -     case NFCT_TCP_INVALID:
> > > +     case NFCT_TCP_INVALID: {
> > > +             int verdict = -NF_ACCEPT;
> > > +
> > > +             if (ct->status & IPS_NAT_MASK)
> > > +                     /* If DNAT is enabled and netfilter receives
> > > +                      * out-of-window skbs, we should drop it directly,
> >
> > Yes, if _be_liberal toggle is disabled this can happen.
> >
> > > +                      * or else skb would miss NAT transformation and
> > > +                      * trigger corresponding RST sending to the flow
> > > +                      * in TCP layer, which is not supposed to happen.
> > > +                      */
> > > +                     verdict = NF_DROP;
> >
> > One comment for the SNAT case.
> 
> Thanks for the comment :)
> 
> >
> > nf_conntrack_in() calls this function from the prerouting hook. For
> > the very first packet, IPS_NAT_MASK might not be yet fully set on
> > (masquerade/snat happens in postrouting), then still one packet can be
> > leaked without NAT mangling in the SNAT case.
> 
> It's possible if the flag is not set and out-of-window skb comes first...

Not only out-of-window packets. Any invalid initial packet being sent
that triggers a transition to invalid state will be dropped, eg.
spoofed TCP traffic, right?

> > Rulesets should really need to set default policy to drop in NAT
> > chains to address this.
> >
> > And after this update, user has no chance anymore to bump counters at
> > the end of the policy, to debug issues.
> 
> You mean 'set default policy' is using iptables command to set, right?
> If that's the case, I suspect the word "address" because it just hides
> the issue and not lets people see it. I think many users don't know
> this case. If I tell them about this "just set one more sysctl knob
> and you'll be fine", they will definitely question me... Actually I
> was questioned many times last week.
>
> We have a _be_liberal sysctl knob to "address" this, yes, but what I'm
> thinking is : the less we resort to sysctl knob, the easier life we
> have.
> 
> It's very normal to drop an out-of-window skb without S/DNAT enabled.
> Naturally, we're supposed to drop it finally with S/DNAT enabled. It
> can be the default behaviour. Why would we use a knob to do it
> instead? :/

My concern is that, if conntrack drops invalid traffic by default,
user gets no reports that this is going on other than enabling
conntrack logging, because the rule that matches and drop INVALID
packets does match anymore.

> > We have relied on the rule that "conntrack should not drop packets"
> > since the very beginning, instead signal rulesets that something is
> > invalid, so user decides what to do.
> 
> Yes, I know that rule, but we already have some exceptions for this:
> we dropped the unexpected skb in the netfilter unless there are no
> other better alternatives.
>
> My logic in the V1 patch is not setting invalid (in order to not clear
> skb->_nfct field) and letting it go until it is passed to the TCP
> layer which will drop it finally.
