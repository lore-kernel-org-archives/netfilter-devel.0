Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FC1149E13
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 05:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740459986; cv=none; b=K7+YEUFeVmO7kMTN2S+PU7B++iK2WSgZw/rBXEX5aJ58Mt7Owursi1DaeFVSamKtaqchdPfemv7Oh99dCNINXnUv+g4TzriV27goOBdf8qiucx8Pm5m/eS7F1sU8UJU2GRDvKnlMV59/CerfZDamA52DyhGwHeBLlKNGkdsbHkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740459986; c=relaxed/simple;
	bh=idnJRzJuIFnklne/FGQl1XmZcpL8ClzBm0O8IoaBLAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gG4Y9t6VcIzx6nWCw2+C8pBF1rbTlg2VGGrOOup7OxVist7UITwty+AkxsujOGplaBw6ituZtmX3MKQ+XftsGYb9LM1Zz6kDTga1wHO/G9V2o86OKJZcYpSNUSU8MygszxYqN+PtdYFYlMXRkK4e/TbnYbPZf8qk5zzbV6DHPHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jkcLf9uD; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jkcLf9uD"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-abb892fe379so798184866b.0
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2025 21:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740459983; x=1741064783; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KI5dUjpO6HHPYmhI+j6+d4WaxaXOrRLtTx0RJhCINko=;
        b=jkcLf9uDnH61C3qqcH+bzkPxNh0fL97zXbgEAd9cNJaffShW3oUwhKWk7CrhP2Zwz+
         xylo7aV+GrC3h9iFwRzgqq4SioARwnj7U+A5QBQCwHGcpbQa5PAtvaCKQm2Pd1BwuBcm
         oCxROSqeUGN2Bte+l8qRiijhUoS2Lqff/Z5dV+m7md/D7OGM9v88v6cXAwImDI2dVM/Y
         n9U6/ae2x1z5zjkXZDsqiIlNPBQdmb0KHRM460XSadiykRlwIQROFIPj43yDzG/gXMcf
         UG5+t1EXXA50fx0pYQcpyX2g9CvGEzw9SwCehdxbzdUidQY18LwrvMS7CEuwbigc2/wi
         hdDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740459983; x=1741064783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KI5dUjpO6HHPYmhI+j6+d4WaxaXOrRLtTx0RJhCINko=;
        b=dTv/EKyTeiITEZNWs+Xrd25PRulPnQbB2x14Cw0EQmzb0ahxJaJ2IdDSYQYxJoteCx
         Rgo2hVKayFHE2DzDhC4I983MRbjWR21L1S8wn4yXBQYwynCgxxV/JvtiV4VgEHg2NkbK
         IiyLwXeSPhHL+miME6pHzRqo+dBny8IteqPAVQIF3F5QtocOVVeXaw1teDcfc7F5aI2Y
         O6s5FaXjm6TMQXR9TaAn4PMHXRJFm8QznkJtZz2EvbDto33Y4tnPkzBoyMkSKoZ+FJ9j
         txkyVRAOU+3y9SFiNzv5SNBDP2uNKm303I7nlFNCH8J9oyYWYgdCiLjASO1WkGib92F0
         wDEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwgJRqSVk5ZRDENzPtP/aBRFhCnmY7XRRzEU4iWDJvQu2aWlTPeqDI+LeK9qNTtVKsuDQZwwEOL4p4D39Ttis=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy1vBQE+i5FdEZSre7BN5rMZrkEeaA2wbNzH4UTxRn4ghFh1H0
	SOk661FBXuxoS3ziBuaGKHoOwdFJJMu+y3IuXGJcJN88bTkEZQPpScMbmt0MU1Z6o/ENIHtl72d
	9CwFtriJ4LAxA5bFHmGRq1hkPiyNlyZm2
X-Gm-Gg: ASbGnctMEeCSA8FltKeG+MhHnJtj3EvDgA5DkcYwP/RHYyCSCBw3/cMqEb6JelKEKOQ
	1RhldWaQdAL8ZYS9EEISPTB4EDB6UqZjuhX3paJ6oBLUSOlk1RwAQ+IyhjPalcSiH6ln+gk1C+E
	qoGK6CWTg=
X-Google-Smtp-Source: AGHT+IFoq8tcF0GVSsN3WayNSX7Q2djA8ZHmODUc86IGoA50KOItWQwCC8Bc1SNnr8cBUsNuCk6GoIl34lpzMUxqKfw=
X-Received: by 2002:a05:6402:50c7:b0:5e0:7510:5787 with SMTP id
 4fb4d7f45d1cf-5e4469ddac9mr4178877a12.19.1740459983108; Mon, 24 Feb 2025
 21:06:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALkUMdRzOt48g3hk3Lhr5RuY_vTi7RGjn8B3FyssHGTkhjagxw@mail.gmail.com>
 <642q17p7-p69n-qn52-4617-6540pso33266@vanv.qr> <CALkUMdRa5uRo=j4j=Y=TtJe2OW1OC3sAi8U0kSRx7oZvFoNZxA@mail.gmail.com>
 <20250224135642.GA9387@breakpoint.cc>
In-Reply-To: <20250224135642.GA9387@breakpoint.cc>
From: Vimal Agrawal <avimalin@gmail.com>
Date: Tue, 25 Feb 2025 10:36:10 +0530
X-Gm-Features: AWEUYZk15jIfmWMMX8njs9noksZSpVnNxON_w7qVsRXIZLFdItP2aS4_TeID_3w
Message-ID: <CALkUMdS+-O15_rkqXz8KGPt4zghfR8S4Gh81RBFdYwqfAk-O+w@mail.gmail.com>
Subject: Re: Byte order for conntrack fields over netlink
To: Florian Westphal <fw@strlen.de>
Cc: Jan Engelhardt <ej@inai.de>, netfilter-devel@vger.kernel.org, 
	Dirk VanDerMerwe <Dirk.VanDerMerwe@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Florian,

Find below the patch:

From: Vimal Agrawal <vimal.agrawal@sophos.com>

All conntrack fields are sent to userspace in network byte order and
hence conntrack tool is expecting id also to be in network byte order

Tested by adding pr_info in ctnetlink_dump_id()
Without fix:
root@(none):/# conntrack -L -o id
ctnetlink_dump_id: ct_id=3D3208799198
tcp      6 177 NONE src=3D1.1.1.1 dst=3D2.2.2.2 sport=3D111 dport=3D222 [UN=
REPLIED]
src=3D2.2.2.2 dst=3D1.1.1.1 sport=3D222 dport=3D111 mark=3D0 use=3D1 id=3D3=
731047103
note that ids are not matching in kernel and userspace

with fix:
root@(none):/# conntrack -L -o id
ctnetlink_dump_id: ct_id=3D4236436704
tcp      6 184 NONE src=3D1.1.1.1 dst=3D2.2.2.2 sport=3D111 dport=3D222 [UN=
REPLIED]
src=3D2.2.2.2 dst=3D1.1.1.1 sport=3D222 dport=3D111 mark=3D0 use=3D1 id=3D4=
236436704
ids are matching now in kernel and userspace

Fixes: 3c79107631db ("netfilter: ctnetlink: don't use conntrack/expect
object addresses as id")
Signed-off-by: Vimal Agrawal <vimal.agrawal@sophos.com>
---
 net/netfilter/nf_conntrack_netlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c
b/net/netfilter/nf_conntrack_netlink.c
index 334db22199c1..bb963f13c2c0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -513,7 +513,7 @@ static int ctnetlink_dump_ct_synproxy(struct
sk_buff *skb, struct nf_conn *ct)

 static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct=
)
 {
-       __be32 id =3D (__force __be32)nf_ct_get_id(ct);
+       __be32 id =3D htonl(nf_ct_get_id(ct));

         if (nla_put_be32(skb, CTA_ID, id))
                 goto nla_put_failure;
@@ -1625,9 +1625,9 @@ static int ctnetlink_del_conntrack(struct sk_buff *sk=
b,
         ct =3D nf_ct_tuplehash_to_ctrack(h);

         if (cda[CTA_ID]) {
-               __be32 id =3D nla_get_be32(cda[CTA_ID]);
+               u32 id =3D ntohl(nla_get_be32(cda[CTA_ID]));

-               if (id !=3D (__force __be32)nf_ct_get_id(ct)) {
+               if (id !=3D nf_ct_get_id(ct)) {
                         nf_ct_put(ct);
                         return -ENOENT;
                 }
--=20
2.17.1

Vimal

On Mon, Feb 24, 2025 at 7:26=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Vimal Agrawal <avimalin@gmail.com> wrote:
> > if (nla_put_be32(skb, CTA_ID, id))
> > ...
> > }
> >
> > I don't see ntohl being done for this field.
>
> I already told you: its a random value and thus doesn't
> have a 'byte order' in the first place.
>
> You can make a patch to do the conversion, but it doesn't
> change anything.
