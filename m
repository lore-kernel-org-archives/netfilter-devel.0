Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6286D10E3;
	Fri, 22 Mar 2024 01:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711069642; cv=none; b=JOc0z5JX1ujYQKEi/kqhwRb36BbVdidqK9po1vfm619vWYQ/C2TiugxsVX7SJUSI7YRNFrb4Xe+Gpv8Xm2uEbx2JmJQnaE6CbHgxPYJYvKIIKTscaUWah9ZZzFcmBmrSn4QJ0gArsYCKsLf1WAmXqO9neJ2ymFBWXvxRztyLqAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711069642; c=relaxed/simple;
	bh=nJns0ykI9BUIolxCHFqmEyPMsLF/6Gg8ckxT3RYpSPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KgIt6vfNvZ5OqMFG+FeoK+qX5hwAXKvTQTGgJjCQWg7q/ZSFq8A1lyOGINh5K05NdyAZsOoZXw05BkLImRmrLGbJGizReUwshuMRp4q8GtmXA716raaw/+vu7yqVkqrUSCdSfbEh3KHAMfagvjed1vLj6JN0l2YYm1t28x2fC48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fOD4c2OG; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fOD4c2OG"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-513e6777af4so2996226e87.2;
        Thu, 21 Mar 2024 18:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711069638; x=1711674438; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4Uuo87+sc0z28M9xFIQmQL9MvP8aEW+1s2QNiqTOto=;
        b=fOD4c2OGCGv5W10SsmejSxiem7Qd8QfwNKZJCPxn3C01/kcbGA9RsmDwUUjcBmkF+F
         Z4usr6Oldz0U7nAcxYqktlY1t/7JC6PzyERFLirnOoqsCIcz0R0ELNhrzfKaOeHcBQZs
         qn4pcTyPQuCqpq+R/y0JbkE5SgqfyncPiM99yze+K2EfR4n5wkWoC2lYfr32ZD/aci8w
         dTxeiHbLnISWTa4hPXeBXHDruPOkBruLLxiaEdXUJPBf0D3s72H7hv7+chBAj+STEBaB
         /dmf302odOVM280Xi2Zd8wC+iZgVn016UwYimc40TWD1yfZ4GnytD5sgnAO6IhP9ZTwf
         IR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711069638; x=1711674438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e4Uuo87+sc0z28M9xFIQmQL9MvP8aEW+1s2QNiqTOto=;
        b=RsBvM6bFKkPTu1R+em02ejvKVppatDYUAu5vrsF+7kaJvXHQxNZJxmB8OfSNGAZd35
         EIMpXhPiiZEWMYrV1vV2BFRIuTXz6apbyiCJSR8pz5tzDmv70JNvTPpKz5bNcdveOHbk
         k5N14ZvK9P0PvHE3ZA6Sdhv0EnMtwgUmPnuA8OOaFXfQhtRzFa1PSj1eRM9HPFj2hwZu
         bRR3rKk7rM4WIiyOgBSGsKHmuBU6hqNaq6pht/lCg+YUy01U7ErYS0Vlt+PT+4ErOsgm
         hdadf5dJBBa0wKKtZeh2yQCn4j3+FvuZURH7A0e+2l9DB6i5yPl8FgSpDjEDzkB7+RvC
         I1Bw==
X-Forwarded-Encrypted: i=1; AJvYcCWCDfy22ZPMNBsTn1jdV028VbMKvDPulPaIeHanaZlkFJkKnHNBzVI3vf/ffpFDwwByKJ0dqHT1aw5aAKJNJP7q7CIOOIBe3UZJQzHDQj/4x9jtYtWp+JYpt6gcCAEnZMF2gTsUBmaj
X-Gm-Message-State: AOJu0Yz2zila2tHOG1UzGUv6Q5tL8JUilOESBrvXyWMY6fJzHrBj19il
	BOv358oa2oMGogikkO6V4ePLAiK32Uu9/q/+j0PE7Jn/mz7Cc6ZVxgrpDz3CVAxStj6jSs03otq
	izIbT7X8H759SJMVlNYrqA81Dle0=
X-Google-Smtp-Source: AGHT+IHlZCJ8LWEW3G10FVuiLTWDrENwNdsLK8C9nLfvPwUNiYXR/MTREIrRQsIhAi3XkjM7G2BCrGM3AQVbCRrqFLM=
X-Received: by 2002:ac2:5214:0:b0:513:c50d:db59 with SMTP id
 a20-20020ac25214000000b00513c50ddb59mr685402lfl.15.1711069638179; Thu, 21 Mar
 2024 18:07:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240311070550.7438-1-kerneljasonxing@gmail.com> <ZfyhR_24HmShs78t@calendula>
In-Reply-To: <ZfyhR_24HmShs78t@calendula>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Fri, 22 Mar 2024 09:06:41 +0800
Message-ID: <CAL+tcoBHU7RKWvDkDVK+8poXK_XdNU0sskwuY6R-B0oatmDOxg@mail.gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: edumazet@google.com, kadlec@netfilter.org, fw@strlen.de, kuba@kernel.org, 
	pabeni@redhat.com, davem@davemloft.net, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, 
	Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Pablo,

On Fri, Mar 22, 2024 at 5:06=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Mon, Mar 11, 2024 at 03:05:50PM +0800, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Supposing we set DNAT policy converting a_port to b_port on the
> > server at the beginning, the socket is set up by using 4-tuple:
> >
> > client_ip:client_port <--> server_ip:b_port
> >
> > Then, some strange skbs from client or gateway, say, out-of-window
> > skbs are eventually sent to the server_ip:a_port (not b_port)
> > in TCP layer due to netfilter clearing skb->_nfct value in
> > nf_conntrack_in() function. Why? Because the tcp_in_window()
> > considers the incoming skb as an invalid skb by returning
> > NFCT_TCP_INVALID.
> >
> > At last, the TCP layer process the out-of-window
> > skb (client_ip,client_port,server_ip,a_port) and try to look up
> > such an socket in tcp_v4_rcv(), as we can see, it will fail for sure
> > because the port is a_port not our expected b_port and then send
> > back an RST to the client.
> >
> > The detailed call graphs go like this:
> > 1)
> > nf_conntrack_in()
> >   -> nf_conntrack_handle_packet()
> >     -> nf_conntrack_tcp_packet()
> >       -> tcp_in_window() // tests if the skb is out-of-window
> >       -> return -NF_ACCEPT;
> >   -> skb->_nfct =3D 0; // if the above line returns a negative value
> > 2)
> > tcp_v4_rcv()
> >   -> __inet_lookup_skb() // fails, then jump to no_tcp_socket
> >   -> tcp_v4_send_reset()
> >
> > The moment the client receives the RST, it will drop. So the RST
> > skb doesn't hurt the client (maybe hurt some gateway which cancels
> > the session when filtering the RST without validating
> > the sequence because of performance reason). Well, it doesn't
> > matter. However, we can see many strange RST in flight.
> >
> > The key reason why I wrote this patch is that I don't think
> > the behaviour is expected because the RFC 793 defines this
> > case:
> >
> > "If the connection is in a synchronized state (ESTABLISHED,
> >  FIN-WAIT-1, FIN-WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT),
> >  any unacceptable segment (out of window sequence number or
> >  unacceptible acknowledgment number) must elicit only an empty
> >  acknowledgment segment containing the current send-sequence number
> >  and an acknowledgment..."
> >
> > I think, even we have set DNAT policy, it would be better if the
> > whole process/behaviour adheres to the original TCP behaviour as
> > default.
> >
> > Suggested-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> > v2
> > Link: https://lore.kernel.org/netdev/20240307090732.56708-1-kerneljason=
xing@gmail.com/
> > 1. add one more test about NAT and then drop the skb (Florian)
> > ---
> >  net/netfilter/nf_conntrack_proto_tcp.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_=
conntrack_proto_tcp.c
> > index ae493599a3ef..19ddac526ea0 100644
> > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > @@ -1256,10 +1256,21 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
> >       case NFCT_TCP_IGNORE:
> >               spin_unlock_bh(&ct->lock);
> >               return NF_ACCEPT;
> > -     case NFCT_TCP_INVALID:
> > +     case NFCT_TCP_INVALID: {
> > +             int verdict =3D -NF_ACCEPT;
> > +
> > +             if (ct->status & IPS_NAT_MASK)
> > +                     /* If DNAT is enabled and netfilter receives
> > +                      * out-of-window skbs, we should drop it directly=
,
>
> Yes, if _be_liberal toggle is disabled this can happen.
>
> > +                      * or else skb would miss NAT transformation and
> > +                      * trigger corresponding RST sending to the flow
> > +                      * in TCP layer, which is not supposed to happen.
> > +                      */
> > +                     verdict =3D NF_DROP;
>
> One comment for the SNAT case.

Thanks for the comment :)

>
> nf_conntrack_in() calls this function from the prerouting hook. For
> the very first packet, IPS_NAT_MASK might not be yet fully set on
> (masquerade/snat happens in postrouting), then still one packet can be
> leaked without NAT mangling in the SNAT case.

It's possible if the flag is not set and out-of-window skb comes first...

>
> Rulesets should really need to set default policy to drop in NAT
> chains to address this.
>
> And after this update, user has no chance anymore to bump counters at
> the end of the policy, to debug issues.

You mean 'set default policy' is using iptables command to set, right?
If that's the case, I suspect the word "address" because it just hides
the issue and not lets people see it. I think many users don't know
this case. If I tell them about this "just set one more sysctl knob
and you'll be fine", they will definitely question me... Actually I
was questioned many times last week.

We have a _be_liberal sysctl knob to "address" this, yes, but what I'm
thinking is : the less we resort to sysctl knob, the easier life we
have.

It's very normal to drop an out-of-window skb without S/DNAT enabled.
Naturally, we're supposed to drop it finally with S/DNAT enabled. It
can be the default behaviour. Why would we use a knob to do it
instead? :/

>
> We have relied on the rule that "conntrack should not drop packets"
> since the very beginning, instead signal rulesets that something is
> invalid, so user decides what to do.

Yes, I know that rule, but we already have some exceptions for this:
we dropped the unexpected skb in the netfilter unless there are no
other better alternatives.

My logic in the V1 patch is not setting invalid (in order to not clear
skb->_nfct field) and letting it go until it is passed to the TCP
layer which will drop it finally.

>
> I'm ambivalent about this, Jozsef?

Hope to see more comments and suggestions from you two maintainers :)

Thanks,
Jason

>
> >               nf_tcp_handle_invalid(ct, dir, index, skb, state);
> >               spin_unlock_bh(&ct->lock);
> > -             return -NF_ACCEPT;
> > +             return verdict;
> > +     }
> >       case NFCT_TCP_ACCEPT:
> >               break;
> >       }
> > --
> > 2.37.3
> >
