Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4D125FA05
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 20:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777407354; cv=pass; b=afULjdDVFbWztcKSKHMEsFNgALPBLi2QeluQQtkA/4LhLFyrUMa/SuewkH0WesYndsUwLdgl4WZmq7ogd3FeK4NRqvzGdVUj9eSMGDVhWKPsQRaFv1dNQf9Ab5MSbAfr/Nt1wehCTeg1Uusp3sSHav7AS3nBx65kvvsVNxFVegU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777407354; c=relaxed/simple;
	bh=jubsY6PGHnTXGhA5KKyDi/LWS9PbjTsPha5xbgCuu/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CcjcT6rr2t5oltJf5MBanZGTM+8puySF1Nora7X8u/Jt6IlU2oMecEHGCajrIDWl16RJjGWVhlmyayMnLa9Snh90On0TdmWUHRiRtgBHypMzMkj+wz7iRIK7Yk8oeKqMtRm8Bz+XHiPuaHBNNYAfHB2i7GFIkSTiXeECFlvCvok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KlhTZCEL; arc=pass smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KlhTZCEL"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82f9fdfc965so4822745b3a.1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 13:15:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777407353; cv=none;
        d=google.com; s=arc-20240605;
        b=igBXgRMatx4MYrVwNxfDT1GOSX1gbdvwYWIr9mF4LYgU5faU8xz0ftUQQlIewrLyY6
         Csv3WRYck+o5FGa2l3+QkXFUu7qhM4tlzXs5/+tdbJVYagVyf9ae83t7rK28gcGKGHzu
         +ter1LGewNaYYd4ql4Tz7I5gCBlpzfGBQISu00BHgNTawdg9pHaRDW6/RzBXBW6vyCGx
         82QsPTpB6k2nGF2bDfikFDH6uEzL1cD/cTG55conIJv4RBnGYORimNUTWVLNdWbYMu1o
         FtiP/pE1US1ZouUSl0DNHgvj6dtRIIggVPa3zjSOwL8Zmv0bwcWoMYgYHYBSSPxUB9Vb
         nSag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uQV+ZUo0kltumkkS/38YnBQvpZ5Ru0K+aNTeRpdyz74=;
        fh=/qhlLF6Ita+oB42LPl2GTS5UkBhHCTiZ8SE+c0x9POg=;
        b=SovVt7WMxA7bnMCWEUitsLQlmt0qK4w6/zihYgjwQihf9dOqNb5sii39YfOOjy2ufY
         xDm4XxFNKHGSTOf/VnlvzSKVuy/66ImM5d6vsI1CXyNkfVnMYgL4UKGaGOrP3aViQd5t
         kRlWT18z3QxqaoRAw3cRRb96GhT3q3P8Nyl3UikG7q19VbBFfrMcNBsI6LQG+0H1wbmd
         sN5Y4OwokfPgU8A6ncIf9KY6k/Lt0KXxlpIawNDMqbC/T3ooRfT50Th9XEN8OdUSmCdh
         PIoDiUrzUCEl6iNtiEvNBeElOPEgDclYAhwQDhd8FoF4rF21FzmY5MFI/vnqkByBkZa0
         BWGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777407353; x=1778012153; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQV+ZUo0kltumkkS/38YnBQvpZ5Ru0K+aNTeRpdyz74=;
        b=KlhTZCELSkeBlc2IBRjM/spYNSJcZEx+XzogZUf8EXFJF3JgePK7hmDvz5NuTFJiJv
         0BK3ai6GXs6Ba5FV/d4g1cdK/BL6ls/W71AfgslX1RqhbkmZGwqATBsS3wGqmGeH6nb/
         xNU61DVSE4tbJYhfIKjDVbPYfQHKGcxwSbWUEqeSX2GlYVe7n1TWGmwLyTSdTy2lzZnj
         VNdG2g0+RgBVVsWPCECBHC8P2dK1ajWkNZH/0ZwWaclyCSZEiTKU6Gl1JhiyMvC/Ti3k
         KiEHqJicHui4HFNs3+FoX2afrvltIR+2kaN7IlVkx5wnlKskFTKJ6aVIH+p0ujd5d0bl
         zUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777407353; x=1778012153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uQV+ZUo0kltumkkS/38YnBQvpZ5Ru0K+aNTeRpdyz74=;
        b=KyM9oVo16lI3B4ajcCxNY9Q7lMuG55XD65U3XylprZ6qCMyEZ1AX9Ff408iQAw0pOz
         UIcmfpSmGj+RATas8ii35NN8OFAJaQT1VBu0ZsZbeoN3xUy/+UOV9Wmu6d2h88g9kFYE
         r/mDFmukzXJLVfo7vTbrjAQNIYl3Dd8QYPr4GVUKVSSYyAG+KZTadw9v+1cCDD97dG0S
         u4eFvTLYZlhXVRK2G4hFbpixCelGXXQVjKd0IAM3SEzpqOIkplWdTw/ybYzVetLK0MOO
         pC8vTlESzesl0t7JII0QuTf0dKTWdrKDsqlOGOCwkCQbivsX6HCFcpQ7g9OcVa6AhG9q
         U06A==
X-Forwarded-Encrypted: i=1; AFNElJ+19sddNGxjBLtbBYJQBT8y5eETIrSzksHGh+Eg1tx8xY1wZmsxWM8uAv52Qxze4mZ2BsW/tvnyaLmIFV11zDU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ1OQXwW6K5iVSvMaNE7wfr7UUh19LUp4Bb31Xb+PEQgiocnPI
	eErS/0ZFNabFwAfpF8+NIp6rRMD6nLc4C6LYaEQrUNKGZdxhEil/VPK9Eaapdzn7jmBB15kGnMB
	0zLcGP65CjulbNK+ym85pv39xcwuQuzE=
X-Gm-Gg: AeBDieuzA4/uR9m6yMJuNxODFvXr72bx2A6fkGplkfU6OBZtoavx393UO5X3mUUDmuv
	He7Bt00oanwp1Ol2R8mS+kS4H194w3eOOAVenC14t8xRdJvcJdRBvY3bTBqhPb2rqHqBQnlgFR9
	TbfdcRwIdyTOtwvEffgWt7BvglfOTctvE3QZBmez/EcdKoVZwv2fF0xdV+thTmN+oXYobyAJmtI
	5eorFvc7UY5JCaCuGVbnDM3u2ConcnY6G3fBmhXPraxXtyDOCsA53jfuZl8Io2PYeyz4SV81zjT
	sQowRSF904apztrytnFjT9Z8EroF6c15ryHm/8jOUkXXyez/THQieYBxMfg/P1R9Ky7ljvLCGKY
	Y2HU31D8uFadqYgwHX8+0tIxJLCaK0vdl5oE2n9AYN5yKuxFs9g==
X-Received: by 2002:a05:6a00:f9a:b0:82c:2155:5b6d with SMTP id
 d2e1a72fcca58-834ddabdb7dmr4872052b3a.12.1777407352913; Tue, 28 Apr 2026
 13:15:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777214801.git.lucien.xin@gmail.com> <20260428140642.GT900403@horms.kernel.org>
In-Reply-To: <20260428140642.GT900403@horms.kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 28 Apr 2026 16:15:40 -0400
X-Gm-Features: AVHnY4Kx985VXS0AEmk_DrhzVNCcnQW-CWSjNlk5dYUnFRn6jZWfAV-j5B80K0Q
Message-ID: <CADvbK_dNRkb8UeGi+x=HhH+tJZSpUTDyHdQLDxUQA1dinbaFNg@mail.gmail.com>
Subject: Re: [PATCH net v2 0/2] sctp: fix a vtag verification failure caused
 by stale INITs
To: Simon Horman <horms@kernel.org>
Cc: network dev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org, 
	linux-sctp@vger.kernel.org, davem@davemloft.net, kuba@kernel.org, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Yi Chen <yiche.cy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 28, 2026 at 10:06=E2=80=AFAM Simon Horman <horms@kernel.org> wr=
ote:
>
> On Sun, Apr 26, 2026 at 10:46:39AM -0400, Xin Long wrote:
> > Similar to Scenario B in commit 8e56b063c865 ( netfilter: handle the
> > connecting collision properly in nf_conntrack_proto_sctp"):
> >
> > Scenario B: INIT_ACK is delayed until the peer completes its own handsh=
ake
> >
> >   192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
> >     192.168.1.1 > 192.168.1.2: sctp (1) [INIT] [init tag: 144230885]
> >     192.168.1.2 > 192.168.1.1: sctp (1) [INIT ACK] [init tag: 392221640=
8]
> >     192.168.1.1 > 192.168.1.2: sctp (1) [COOKIE ECHO]
> >     192.168.1.2 > 192.168.1.1: sctp (1) [COOKIE ACK]
> >   192.168.1.1 > 192.168.1.2: sctp (1) [INIT ACK] [init tag: 3914796021]=
 *
> >
> > There is another case:
> >
> > Scenario F: INIT is delayed until the peer completes its own handshake
> >
> >   192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
> >   (OVS upcall)
> >     192.168.1.1 > 192.168.1.2: sctp (1) [INIT] [init tag: 144230885]
> >     192.168.1.2 > 192.168.1.1: sctp (1) [INIT ACK] [init tag: 392221640=
8]
> >     192.168.1.1 > 192.168.1.2: sctp (1) [COOKIE ECHO]
> >     192.168.1.2 > 192.168.1.1: sctp (1) [COOKIE ACK]
> >   192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
> >   (delayed)
> >   192.168.1.1 > 192.168.1.2: sctp (1) [INIT ACK] [init tag: 3914796021]=
 *
> >
> > In this case, the delayed INIT (e.g. due to OVS upcall) is recorded by
> > conntrack, which prevents vtag verification from dropping the unexpecte=
d
> > INIT-ACK in nf_conntrack_sctp_packet():
> >
> >   vtag =3D ct->proto.sctp.vtag[!dir];
> >   if (!ct->proto.sctp.init[!dir] && vtag && vtag !=3D ih->init_tag)
> >           goto out_unlock;
> >
> > This happens because ct->proto.sctp.init[!dir] is set by the delayed IN=
IT,
> > even though it is stale.
> >
> > Fix this in two parts:
> >
> > - In netfilter: Do not record INITs whose init_tag matches the peer vta=
g,
> >   as they carry no new handshake state in the 1st patch.
> >
> > - In SCTP: Prevent endpoints from responding to such INITs with INIT-AC=
K,
> >   ensuring correctness even when middleboxes lack the netfilter fix in
> >   the 2nd patch.
> >
> > A follow-up selftest for this scenario will be posted in a separate pat=
ch
> > by Yi Chen.
>
> Hi Xin,
>
> FTR: There is an AI generated review of this patchset available on
> sashiko.dev. I have looked over this and I do not believe the feedback
> there should block progress of this patchset.
Right, the feedback is false in practice::

- "No response" is not a clean signal
  (could be loss, firewall, rate limiting, etc.).
- Even guessing this init_tag does not let attackers hijack the association
  (they still lack the correct verification tag and state).

Thanks.
