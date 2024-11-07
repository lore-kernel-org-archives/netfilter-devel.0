Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0244194AD6;
	Thu,  7 Nov 2024 19:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731007979; cv=none; b=tKwh1MY7x4LcqtMCQmxe54Tkkx2yGGmJWXcxs0hdmYsKm6tmqg7m/RSR1j9dPy/2nywT3eajcscxky06Jao7Q087NAxhlE6sUL5N168IgNOoNx8lZQGdXWS8DkDtCZC7RUO499qGj+YuhGNc3Ov4mzcZNnDCLc8i0mgQCsy0ynk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731007979; c=relaxed/simple;
	bh=39GPFKw/G3anFjOTu3aS5+3SF3Xb0WGH5xeMiKYrbMY=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TKme1YEpdV0i2pxq3HiWUwE9BjYPEavzmyghr8T/yGVcguL3555RUPkNogM6JqwyNZ5DEc3cjI+FMdDIp3IQ+UQ6Rz7I1SknzhRnG5nmtAMByZeK0wc9WFVeiafcaz1THMMbMTxrWzRMNO9MlWv+1qXtH1o6tSMa6rqVKcG3Ihg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a33Jb7UH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a33Jb7UH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE334C4CED2;
	Thu,  7 Nov 2024 19:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731007979;
	bh=39GPFKw/G3anFjOTu3aS5+3SF3Xb0WGH5xeMiKYrbMY=;
	h=From:Date:To:cc:Subject:In-Reply-To:References:From;
	b=a33Jb7UHlml7RmTADLXE2JO/mlxosSmG1wfFO/2qonBF01IzsrlmPLZaxfNLc+KbC
	 kymtVqHpzD1xSK5/emekLnhBcBVyavbRRUnBlLp892XouHinqH3snAYi/ye0dfpjKN
	 0RthdELdHJZM04ozRUk7cfNi5KZeqW61nUBvWIADdFARa4rrsfyUZ9SEXGyTa8PSHV
	 jJpRrtJLfZHWaYEieYKYdF2H7y1+kFH1tjwKbwEH/Nl/Ym+q6PWLMUppGGvg5MgDMr
	 z38Dr5dtbbeVCqqBYSI5w9KwKzbrgn3LDlDfLKXo7hZWak+U26+72o97aX0csG0TwI
	 ezx/gqmqbeT6g==
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ij@kernel.org>
Date: Thu, 7 Nov 2024 21:32:54 +0200 (EET)
To: Eric Dumazet <edumazet@google.com>
cc: chia-yu.chang@nokia-bell-labs.com, netdev@vger.kernel.org, 
    dsahern@gmail.com, davem@davemloft.net, dsahern@kernel.org, 
    pabeni@redhat.com, joel.granados@kernel.org, kuba@kernel.org, 
    andrew+netdev@lunn.ch, horms@kernel.org, pablo@netfilter.org, 
    kadlec@netfilter.org, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, ncardwell@google.com, 
    koen.de_schepper@nokia-bell-labs.com, g.white@cablelabs.com, 
    ingemar.s.johansson@ericsson.com, mirja.kuehlewind@ericsson.com, 
    cheshire@apple.com, rs.ietf@gmx.at, Jason_Livingood@comcast.com, 
    vidhi_goel@apple.com
Subject: Re: [PATCH v5 net-next 01/13] tcp: reorganize tcp_in_ack_event()
 and tcp_count_delivered()
In-Reply-To: <CANn89iLEC4Gwr1P8x3tpFVFObvB4nM5xt0F=nRBNe1hqYOLU9A@mail.gmail.com>
Message-ID: <fd509ff1-c97a-625f-6423-cf24871cf124@kernel.org>
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-2-chia-yu.chang@nokia-bell-labs.com> <CANn89iLEC4Gwr1P8x3tpFVFObvB4nM5xt0F=nRBNe1hqYOLU9A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1036980939-1731007974=:1016"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1036980939-1731007974=:1016
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 7 Nov 2024, Eric Dumazet wrote:

> On Tue, Nov 5, 2024 at 11:07=E2=80=AFAM <chia-yu.chang@nokia-bell-labs.co=
m> wrote:
> >
> > From: Ilpo J=C3=A4rvinen <ij@kernel.org>
> >
> > - Move tcp_count_delivered() earlier and split tcp_count_delivered_ce()
> >   out of it
> > - Move tcp_in_ack_event() later
> > - While at it, remove the inline from tcp_in_ack_event() and let
> >   the compiler to decide
> >
> > Accurate ECN's heuristics does not know if there is going
> > to be ACE field based CE counter increase or not until after
> > rtx queue has been processed. Only then the number of ACKed
> > bytes/pkts is available. As CE or not affects presence of
> > FLAG_ECE, that information for tcp_in_ack_event is not yet
> > available in the old location of the call to tcp_in_ack_event().
> >
> > Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> > Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
> > ---
> >  net/ipv4/tcp_input.c | 56 +++++++++++++++++++++++++-------------------
> >  1 file changed, 32 insertions(+), 24 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 5bdf13ac26ef..fc52eab4fcc9 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c

> > @@ -3856,12 +3861,23 @@ static void tcp_process_tlp_ack(struct sock *sk=
, u32 ack, int flag)
> >         }
> >  }
> >
> > -static inline void tcp_in_ack_event(struct sock *sk, u32 flags)
> > +static void tcp_in_ack_event(struct sock *sk, int flag)
> >  {
> >         const struct inet_connection_sock *icsk =3D inet_csk(sk);
> >
> > -       if (icsk->icsk_ca_ops->in_ack_event)
> > -               icsk->icsk_ca_ops->in_ack_event(sk, flags);
> > +       if (icsk->icsk_ca_ops->in_ack_event) {
> > +               u32 ack_ev_flags =3D 0;
> > +
> > +               if (flag & FLAG_WIN_UPDATE)
> > +                       ack_ev_flags |=3D CA_ACK_WIN_UPDATE;
> > +               if (flag & FLAG_SLOWPATH) {
> > +                       ack_ev_flags =3D CA_ACK_SLOWPATH;
>=20
> This is removing the potential CA_ACK_WIN_UPDATE, I would suggest :
>=20
> ack_ev_flags |=3D CA_ACK_SLOWPATH;

Yes, a good catch.

--=20
 i.


> > +                       if (flag & FLAG_ECE)
> > +                               ack_ev_flags |=3D CA_ACK_ECE;
> > +               }
> > +
> > +               icsk->icsk_ca_ops->in_ack_event(sk, ack_ev_flags);
> > +       }
> >  }
> >
> >
>=20
--8323328-1036980939-1731007974=:1016--
