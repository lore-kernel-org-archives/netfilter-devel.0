Received: from smtp0-kfki.kfki.hu (smtp0-kfki.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DD81E53A;
	Fri, 22 Mar 2024 20:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711138917; cv=none; b=rvCcJRQiBTbC0Icv+hBjhGtn8UQyQoJJGTVb2KuNzjut4d2bPeBbeoPPG8nxq/E4tb/WIxsLQxYIdk8d6raL7luVEDTFFvyNfyPOj9U7Ut/tkk6D1OZCqP97hCrPSi1IVC20+GNW6hytoyHD9KW9lE5duZfJeme2lhpf7dJtt7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711138917; c=relaxed/simple;
	bh=pew/DbrYlNuVhBU91Uc8XaU7IxOzE1k0kIs8nxXflgc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XgS9N4U5Afbmu0xP5wYl9/9n0bpIbcw3EeHEy9fbNxeIlawNMhy9ZGL9va6JcVGIcyRJL85TPEJ3xYP08Mru3I5PY3LFfuPU/wrp9iEDsStTzvrRtrGW4jtpcjfR+rVpknLdKvsnKZ2mii/7K0nKA+bB42gHHQ/lyd7TnLpsqRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=JZ9Yp3p0; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="JZ9Yp3p0"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 95403674019E;
	Fri, 22 Mar 2024 21:16:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1711138569; x=1712952970; bh=LoX20vw3Ap
	PwmQEjRd3UCBIStGHb9eQ+4F1x7WOH668=; b=JZ9Yp3p03plWAbxN7ZEQoTmAgT
	aJ6yJVMt6INnIhJARN/NLKagyN+YfYKfY8XIM4rb9OL5G+4BNQSW48NIYVbgQsnk
	T2JXq1Yh/GovcBhRpQUftK6IVl+oWlhj1snSqTx3uE+Ywc2GHwsdWnPZzZBM2ju6
	8FKAjAVTPOT1nxWC4=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
	by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Fri, 22 Mar 2024 21:16:09 +0100 (CET)
Received: from mentat.rmki.kfki.hu (91-83-1-201.pool.digikabel.hu [91.83.1.201])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id A66E26740157;
	Fri, 22 Mar 2024 21:16:08 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 3AF05882; Fri, 22 Mar 2024 21:16:08 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 38175742;
	Fri, 22 Mar 2024 21:16:08 +0100 (CET)
Date: Fri, 22 Mar 2024 21:16:08 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jason Xing <kerneljasonxing@gmail.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, edumazet@google.com, 
    Florian Westphal <fw@strlen.de>, kuba@kernel.org, pabeni@redhat.com, 
    David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, netdev@vger.kernel.org, 
    Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
In-Reply-To: <CAL+tcoDY55yXbo3=OtHpeVOfN8aJmDjwzpd8mRkOH2rMj6QUbA@mail.gmail.com>
Message-ID: <b1b95a71-a4e8-288c-7731-811ad548d641@blackhole.kfki.hu>
References: <20240311070550.7438-1-kerneljasonxing@gmail.com> <ZfyhR_24HmShs78t@calendula> <2aa340d2-c098-9ed8-4e65-896e1d63c2da@blackhole.kfki.hu> <CAL+tcoDY55yXbo3=OtHpeVOfN8aJmDjwzpd8mRkOH2rMj6QUbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1393428146-505008909-1711138568=:18407"
X-deepspam: ham 1%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1393428146-505008909-1711138568=:18407
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Mar 2024, Jason Xing wrote:

> On Fri, Mar 22, 2024 at 6:50=E2=80=AFPM Jozsef Kadlecsik
> <kadlec@blackhole.kfki.hu> wrote:
> >
> > Hi,
> >
> > On Thu, 21 Mar 2024, Pablo Neira Ayuso wrote:
> >
> > > On Mon, Mar 11, 2024 at 03:05:50PM +0800, Jason Xing wrote:
> > > > From: Jason Xing <kernelxing@tencent.com>
> > > >
> > > > Supposing we set DNAT policy converting a_port to b_port on the
> > > > server at the beginning, the socket is set up by using 4-tuple:
> > > >
> > > > client_ip:client_port <--> server_ip:b_port
> > > >
> > > > Then, some strange skbs from client or gateway, say, out-of-windo=
w
> > > > skbs are eventually sent to the server_ip:a_port (not b_port)
> > > > in TCP layer due to netfilter clearing skb->_nfct value in
> > > > nf_conntrack_in() function. Why? Because the tcp_in_window()
> > > > considers the incoming skb as an invalid skb by returning
> > > > NFCT_TCP_INVALID.
> > > >
> > > > At last, the TCP layer process the out-of-window
> > > > skb (client_ip,client_port,server_ip,a_port) and try to look up
> > > > such an socket in tcp_v4_rcv(), as we can see, it will fail for s=
ure
> > > > because the port is a_port not our expected b_port and then send
> > > > back an RST to the client.
> > > >
> > > > The detailed call graphs go like this:
> > > > 1)
> > > > nf_conntrack_in()
> > > >   -> nf_conntrack_handle_packet()
> > > >     -> nf_conntrack_tcp_packet()
> > > >       -> tcp_in_window() // tests if the skb is out-of-window
> > > >       -> return -NF_ACCEPT;
> > > >   -> skb->_nfct =3D 0; // if the above line returns a negative va=
lue
> > > > 2)
> > > > tcp_v4_rcv()
> > > >   -> __inet_lookup_skb() // fails, then jump to no_tcp_socket
> > > >   -> tcp_v4_send_reset()
> > > >
> > > > The moment the client receives the RST, it will drop. So the RST
> > > > skb doesn't hurt the client (maybe hurt some gateway which cancel=
s
> > > > the session when filtering the RST without validating
> > > > the sequence because of performance reason). Well, it doesn't
> > > > matter. However, we can see many strange RST in flight.
> > > >
> > > > The key reason why I wrote this patch is that I don't think
> > > > the behaviour is expected because the RFC 793 defines this
> > > > case:
> > > >
> > > > "If the connection is in a synchronized state (ESTABLISHED,
> > > >  FIN-WAIT-1, FIN-WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT=
),
> > > >  any unacceptable segment (out of window sequence number or
> > > >  unacceptible acknowledgment number) must elicit only an empty
> > > >  acknowledgment segment containing the current send-sequence numb=
er
> > > >  and an acknowledgment..."
> > > >
> > > > I think, even we have set DNAT policy, it would be better if the
> > > > whole process/behaviour adheres to the original TCP behaviour as
> > > > default.
> > > >
> > > > Suggested-by: Florian Westphal <fw@strlen.de>
> > > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > > ---
> > > > v2
> > > > Link: https://lore.kernel.org/netdev/20240307090732.56708-1-kerne=
ljasonxing@gmail.com/
> > > > 1. add one more test about NAT and then drop the skb (Florian)
> > > > ---
> > > >  net/netfilter/nf_conntrack_proto_tcp.c | 15 +++++++++++++--
> > > >  1 file changed, 13 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilt=
er/nf_conntrack_proto_tcp.c
> > > > index ae493599a3ef..19ddac526ea0 100644
> > > > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > > > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > > > @@ -1256,10 +1256,21 @@ int nf_conntrack_tcp_packet(struct nf_con=
n *ct,
> > > >     case NFCT_TCP_IGNORE:
> > > >             spin_unlock_bh(&ct->lock);
> > > >             return NF_ACCEPT;
> > > > -   case NFCT_TCP_INVALID:
> > > > +   case NFCT_TCP_INVALID: {
> > > > +           int verdict =3D -NF_ACCEPT;
> > > > +
> > > > +           if (ct->status & IPS_NAT_MASK)
> > > > +                   /* If DNAT is enabled and netfilter receives
> > > > +                    * out-of-window skbs, we should drop it dire=
ctly,
> > >
> > > Yes, if _be_liberal toggle is disabled this can happen.
> > >
> > > > +                    * or else skb would miss NAT transformation =
and
> > > > +                    * trigger corresponding RST sending to the f=
low
> > > > +                    * in TCP layer, which is not supposed to hap=
pen.
> > > > +                    */
> > > > +                   verdict =3D NF_DROP;
> > >
> > > One comment for the SNAT case.
> > >
> > > nf_conntrack_in() calls this function from the prerouting hook. For
> > > the very first packet, IPS_NAT_MASK might not be yet fully set on
> > > (masquerade/snat happens in postrouting), then still one packet can=
 be
> > > leaked without NAT mangling in the SNAT case.
> > >
> > > Rulesets should really need to set default policy to drop in NAT
> > > chains to address this.
> > >
> > > And after this update, user has no chance anymore to bump counters =
at
> > > the end of the policy, to debug issues.
> > >
> > > We have relied on the rule that "conntrack should not drop packets"
> > > since the very beginning, instead signal rulesets that something is
> > > invalid, so user decides what to do.
> > >
> > > I'm ambivalent about this, Jozsef?
> >
> > [I'm putting on my sysadmin hat.]
> >
> > My personal opinion is that silently dropping packets does not make
> > sysadmin's life easier at all. On the contrary, it makes hunting down
> > problems harder and more challenging: you have got no indication
> > whatsoever why the given packets were dropped.
> >
> > The proper solution to the problem is to (log and) drop INVALID packe=
ts.
> > That is neither a knob nor a workaround: conntrack cannot handle the
> > packets and should only signal it to the rule stack.
> >
> > Actually, the few cases where conntrack itself drops (directly causes=
 it)
> > packets should be eliminated and not more added.
> >
> > Do not blind sysadmins by silently dropping packets.
>=20
> Thanks for the comment.
>=20
> Though I'm not totally convinced, I can live with it because it seems
> there are no other good ways to solve it perfectly, meanwhile
> diminishing my confusion (like resorting to more complex
> configurations).
>=20
> >
> > Jason, the RST packets which triggered you to write your patch are no=
t
> > cause but effect. The cause is the INVALID packets.
>=20
> You could say that.
>=20
> I spent a lot of time tracing down to this area and finally found the
> out-of-window causing the problem, so I ignorantly think other admins
> also may not know about this :(
>=20
> Anyway, thanks to both of you for so much patience and help :)

I understand and appreciate your efforts. But please consider the case=20
when one have to diagnose a failing connection and conntrack drops=20
packets. What should be suspected? Firewall rules? One can enable TRACE=20
and check which rules are hit - but because conntrack drops packet,=20
nothing is shown there. Enable and check conntrack events? Because the=20
packets are INVALID, checking the events does not help either. Only when=20
one runs tcpdump and compares it with the TRACE/NFLOG/LOG entries can one=
=20
spot that some packets "disappeared".

Compare the whole thing with the case when packets are not dropped=20
silently but can be logged via checking the INVALID flag. One can directl=
y=20
tell that conntrack could not handle the packets and can see all packet=20
parameters.

Best regards,
Jozsef

> > > >             nf_tcp_handle_invalid(ct, dir, index, skb, state);
> > > >             spin_unlock_bh(&ct->lock);
> > > > -           return -NF_ACCEPT;
> > > > +           return verdict;
> > > > +   }
> > > >     case NFCT_TCP_ACCEPT:
> > > >             break;
> > > >     }
> > > > --
> > > > 2.37.3
> > > >
> > >
> >
> > --
> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics
> >           H-1525 Budapest 114, POB. 49, Hungary
>=20

--=20
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--1393428146-505008909-1711138568=:18407--
