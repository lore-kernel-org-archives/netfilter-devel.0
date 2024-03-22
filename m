Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165B02C18D;
	Fri, 22 Mar 2024 11:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711105684; cv=none; b=iuW9ar64UDlLFLeWIHH60myFTPbQa1S8tIBAG4Jv7HdIApUwfEj8IqhwyxToCr/OPjOWCulmQlRM+1WYqcgDW9exvfNxsLWOVDutoVrx3KesmuNV2wIV4+koBc078NmQjc2YRgPZuJBk3y9RjryxHKil0CXKJm1S4UJh2TNnTc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711105684; c=relaxed/simple;
	bh=IwLAElmrtl2UROBSOmfOzaUIQs/J6N/xohHvWhYXTcI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aOh49ob5rBQ7LtcpnViPyA6TWrYaqu8HFxU6SGkqDJFjmwWqx3RZfiEd4xFgVIAOXWW2tZWZMaYqNDQ1uXFEwnt6A0lE6XtE8lCWZrKDokti0hdES07MdBdZjPidY7cYZQ4Em27NzHqZOfOoD1FSrwjwqZ6OcGiaUXog2oAjUwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Acr64OaA; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Acr64OaA"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a46dd7b4bcbso263324766b.3;
        Fri, 22 Mar 2024 04:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711105680; x=1711710480; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+VpaGSa8pFznn4vGxdiVTOQlbrLnVfa8cjRLn6exUY=;
        b=Acr64OaAZf30dyy0fs44/aCVKtYrGr13v4Xpbs4bImHVa/BAEtI1aJL4I8aj1sBaOw
         KBXBuPBMrOeg4O6uuFyAkjJP4vzvc22iIlsy4E2If4F4ZGhSlLs0DWtoy/ZAdbXi1UC5
         cG5TpCqyuZ6jucYN9BZb2R4PGVW6CXADceujSjKw5xFOuM9sHtKce2iojBUovpyl2372
         ovecQkhLGkdzQAXlviMpYVYmYXiH9bKmXjx63MWyrLFTGPElmfHKiarDCTKXlC5q18bK
         I3GXS/oFTrqROte/wkO2TNbAtfu7Og1hSv5n7COh0FOIwDkb6xB6/vzamBQFf3mDjBE3
         JWBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711105680; x=1711710480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+VpaGSa8pFznn4vGxdiVTOQlbrLnVfa8cjRLn6exUY=;
        b=lRWfLfdFFIi/oO28ONiJceH0tV8Q3Jo4sMdrbnNhHFBoFVzFxNlCFa0Wwcxtfzv2H2
         eH6pRuciATC6GvoMjg9GJYIG/B2QXKUorXXGSq9DJspoeQpAhheHv2OqMe9FLgvscAAW
         qRgJV6PgiVcL9SoTcWrqgwk/Vl8BBT5ui03NGF5sGkLMJ17ESMQcoUOxk085XqGR2zC6
         tLr8v/2deRMlpEvSGJDZpVpAnVw4hvNqVFApkwGHW357Mmoc+rKZOnSK0fse+8wQFS8k
         Qx8lNfRKuhip7WMK7NM8eAkT1qXRjWvWfdjvyvtUw06y1q0DDw4McB2q4FeizRe27362
         SJWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVr76axmYSPCKvhnrX86mIGg4/ACdRPZGD/XvFJKOBn//tl/26tAWqdz2gyjPOZlONddar6HiSMFZBfO+j6+HgOr0R0CQRKSyK7KbaONIJ/GRjocxyWbh7L7J9TN98AI7Im8LopGQJr
X-Gm-Message-State: AOJu0YwQQwjH5GS+tiCfRvgGsvkthV9siDsBcuXTc7C/hDRCOZrSO6tl
	ymXGgcorkZwJgyrabNg6pUThJC/WuCdCervdzi6bZW0+OxGduof9gdyK7OrQyhQpJ8JvsgNpO3b
	8pO9LGVrOZgIEX6AhfDAx2CWyIoA=
X-Google-Smtp-Source: AGHT+IFjnjCi52ZC8k/CLH04mNag8/POjI9zbgggIZzbnqa4z4oa1o+aXdqnX7OQKhhoFc29FBxcQqCE0l/qoPfVBqI=
X-Received: by 2002:a17:906:c113:b0:a47:2f62:eb8 with SMTP id
 do19-20020a170906c11300b00a472f620eb8mr1193081ejc.64.1711105680030; Fri, 22
 Mar 2024 04:08:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240311070550.7438-1-kerneljasonxing@gmail.com>
 <ZfyhR_24HmShs78t@calendula> <2aa340d2-c098-9ed8-4e65-896e1d63c2da@blackhole.kfki.hu>
In-Reply-To: <2aa340d2-c098-9ed8-4e65-896e1d63c2da@blackhole.kfki.hu>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Fri, 22 Mar 2024 19:07:23 +0800
Message-ID: <CAL+tcoDY55yXbo3=OtHpeVOfN8aJmDjwzpd8mRkOH2rMj6QUbA@mail.gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, edumazet@google.com, 
	Florian Westphal <fw@strlen.de>, kuba@kernel.org, pabeni@redhat.com, 
	David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, 
	Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 22, 2024 at 6:50=E2=80=AFPM Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
>
> Hi,
>
> On Thu, 21 Mar 2024, Pablo Neira Ayuso wrote:
>
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
> > >   -> skb->_nfct =3D 0; // if the above line returns a negative value
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
> > > Link: https://lore.kernel.org/netdev/20240307090732.56708-1-kerneljas=
onxing@gmail.com/
> > > 1. add one more test about NAT and then drop the skb (Florian)
> > > ---
> > >  net/netfilter/nf_conntrack_proto_tcp.c | 15 +++++++++++++--
> > >  1 file changed, 13 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/n=
f_conntrack_proto_tcp.c
> > > index ae493599a3ef..19ddac526ea0 100644
> > > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > > @@ -1256,10 +1256,21 @@ int nf_conntrack_tcp_packet(struct nf_conn *c=
t,
> > >     case NFCT_TCP_IGNORE:
> > >             spin_unlock_bh(&ct->lock);
> > >             return NF_ACCEPT;
> > > -   case NFCT_TCP_INVALID:
> > > +   case NFCT_TCP_INVALID: {
> > > +           int verdict =3D -NF_ACCEPT;
> > > +
> > > +           if (ct->status & IPS_NAT_MASK)
> > > +                   /* If DNAT is enabled and netfilter receives
> > > +                    * out-of-window skbs, we should drop it directly=
,
> >
> > Yes, if _be_liberal toggle is disabled this can happen.
> >
> > > +                    * or else skb would miss NAT transformation and
> > > +                    * trigger corresponding RST sending to the flow
> > > +                    * in TCP layer, which is not supposed to happen.
> > > +                    */
> > > +                   verdict =3D NF_DROP;
> >
> > One comment for the SNAT case.
> >
> > nf_conntrack_in() calls this function from the prerouting hook. For
> > the very first packet, IPS_NAT_MASK might not be yet fully set on
> > (masquerade/snat happens in postrouting), then still one packet can be
> > leaked without NAT mangling in the SNAT case.
> >
> > Rulesets should really need to set default policy to drop in NAT
> > chains to address this.
> >
> > And after this update, user has no chance anymore to bump counters at
> > the end of the policy, to debug issues.
> >
> > We have relied on the rule that "conntrack should not drop packets"
> > since the very beginning, instead signal rulesets that something is
> > invalid, so user decides what to do.
> >
> > I'm ambivalent about this, Jozsef?
>
> [I'm putting on my sysadmin hat.]
>
> My personal opinion is that silently dropping packets does not make
> sysadmin's life easier at all. On the contrary, it makes hunting down
> problems harder and more challenging: you have got no indication
> whatsoever why the given packets were dropped.
>
> The proper solution to the problem is to (log and) drop INVALID packets.
> That is neither a knob nor a workaround: conntrack cannot handle the
> packets and should only signal it to the rule stack.
>
> Actually, the few cases where conntrack itself drops (directly causes it)
> packets should be eliminated and not more added.
>
> Do not blind sysadmins by silently dropping packets.

Thanks for the comment.

Though I'm not totally convinced, I can live with it because it seems
there are no other good ways to solve it perfectly, meanwhile
diminishing my confusion (like resorting to more complex
configurations).

>
> Jason, the RST packets which triggered you to write your patch are not
> cause but effect. The cause is the INVALID packets.

You could say that.

I spent a lot of time tracing down to this area and finally found the
out-of-window causing the problem, so I ignorantly think other admins
also may not know about this :(

Anyway, thanks to both of you for so much patience and help :)

Thanks,
Jason

>
> Best regards,
> Jozsef
>
> > >             nf_tcp_handle_invalid(ct, dir, index, skb, state);
> > >             spin_unlock_bh(&ct->lock);
> > > -           return -NF_ACCEPT;
> > > +           return verdict;
> > > +   }
> > >     case NFCT_TCP_ACCEPT:
> > >             break;
> > >     }
> > > --
> > > 2.37.3
> > >
> >
>
> --
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary
