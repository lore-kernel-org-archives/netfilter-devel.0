Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9B74BCACA
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 18:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783534434; cv=pass; b=m7FoJN5q1GNSoUiXLQVaj1ur8WfzGMZbRx2vP0fgTCBXInWFGjV71OipDs9DLT4TmKzQ/z8WvlYxQGg/rMOYbiZo1XdWcWMfIFuGau0JAbbfj8j5Z26L7VNMefk05Q+01qzi88HfjcurvJt7hYi19mVDMMp1WWafm0WV/oLhbxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783534434; c=relaxed/simple;
	bh=Ef1jX5C1Tf/JqtPxDR2IveLskH1395Bpc8jsazmgvWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RrSR6BDM3LC2Eq3PL1ItvDJr8FgUlkjt8RZIPGrudCMHY4WoAnMG0dLgV0KhXAHiNZac4lrNswtd+CW4XnfoTs5KUqCyort8+FoSRyn2+zOPAtywwmUuPQDF63g6lnTlC6Ns22gGE2pc52FCMX3HtQZXPt90KqZM9fOe2RBfqtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=PA0jfaLp; arc=pass smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="PA0jfaLp"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so13625675ad.1
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jul 2026 11:13:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783534430; cv=none;
        d=google.com; s=arc-20260327;
        b=Hl+WdVOY/9qiFYasVlpyJuhoFE1ftM8Njprj6cBWkE+i8yPd3IjQE7f70uk6DcqYwz
         6B3x0r+7iMlLEj2ytuolIMS1ZKrEXo1DKknF8fYO9riXc6cCyIPdtQv4b9KbWG+ZCuHy
         jB9KWpPsnUlP2Sq72YxiNCs3I2b8bto/921CrjVYA/gQmIFUcIVs7yYu9MW69tmmJc8o
         a6dBpQUQCTGo8K1qxXX8nOfaNUAf/vYcuaNpAiLPydV/4mtPX+z2vuuqhkouldnbRq/i
         8kUMg4ZQ7tijKD4tNKTZKVbbCcGY80iJMZ1QU/JBYCnNy9JtwQk9WyNcpqjpXzZLL70i
         WfyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KPmG3iDrDem82BUtmSEHHGtoKTFS1QWeIgwx+sqCnqc=;
        fh=WxXF0CmCSFQQLCD7yvYnuLLRvj2XNpJZ1DaPrwn00xg=;
        b=jIapmf3cSKHx7VyrIRFSfdrHc5Et5DECGBH97ydAzYG9iSZxEohQFLAR3+ZTMYQf0o
         so9lnNRvEa10veAkEtRxmUN6L8phQ4fVGBg4twByTTo5lXaGCCNqsU0+NubCLD6pAuiI
         D7yL7JBljGGn+WY02KioyEnaOz8Yaq7oL333SREgSVsrXIQiOi23ZypBeDs6EILjGJo/
         Xrw8/PIzVf0Wxi0Ga+tsqHsv+Vu+4MYFWKIpZMXO9+y+tB2Igvdq83E0oNTjMkDOp8Hw
         OXdammykSRtHAj11nF81Yu9mZ0ejdCQi/e8w5O4WiIDPWKwvrXEXL1YL5q3FDsdpIIgy
         HRYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1783534430; x=1784139230; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KPmG3iDrDem82BUtmSEHHGtoKTFS1QWeIgwx+sqCnqc=;
        b=PA0jfaLpG1XzkHkh/jmwcpzir1Vm8W8vYMcyRpwsit5qieadzZOx+VCm9tJESN60Qi
         lQwxre5rMtTOGPuYrXkoK0HclmlG5etVQf3nvJFmu/cpPhCa7qE6NnYhg0ngto/kbLBe
         rWyUrFLLOdCCPcnKj4tRmEFYCQS80Yd7vrHagNCqNeOyLTG4e3gward1T4V6nv0S3cgG
         OLYqI0lezgA+V3Ko2AGoM7P6NX0WNmwUiXWhHpVnBrynuKJ+iGN87oN9cdJjeh5Z0gR+
         ujw56I5ekhQH2yoH+MIRSs+NrbdLz13LwHjhXE3Js1rMxfutbYD7e/pGvhsH0RoVVq2q
         FXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783534430; x=1784139230;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KPmG3iDrDem82BUtmSEHHGtoKTFS1QWeIgwx+sqCnqc=;
        b=Wy4g8KvLtnDTUUVZaw60fXzzcRGy4CdmuKhz2Yyw8tsVGy8uGcgoQj8FYXhcDmF4oj
         9wVNrIXqvpUpabAb1XmfJZB8K628t7n8MHyd02ED8BoN79GXyXi9jmAnuYy5+u7sF3Cq
         MDh7udGXZd+seZpGRtT+lLc4Zj/s9a9eLWPOmw/n8ol4Wotn7DdkP0GiVjaaMs/tvGiA
         5nRZJW5ipsRH9vXffzeey0xJvEEjGRnGc68FrGCJJ7l+Chb/yZ3yKC90E+LnEkkvSlAr
         klMt6kHMnAJ7vfI6qjcRRqpVzrBMvHyWXKoOTLrta/4FMYtgDuuZFL8m45C/+nQ3ZNYx
         60QA==
X-Forwarded-Encrypted: i=1; AHgh+RqM9Uc1/CtiPLTJsKapoUThlmjNjS3ksVfin6rV9/VeT8yPeUwY1X38jNJJ53K4TDL932v745mD1E5J6Dcj/As=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWIiaSsg3AQ0IF3GvP8mSEBZyI1HTHDv6ksemB6Ed6tyjxeHM9
	ilHNxB0OoQVA+YRO7Iser9tlhhOSnfQlKN4DrGbK5jOj9CNRqYJUitHhUYn289nfPgb0c0dYGGK
	vwHiJq5RWiFGexNY9XixEocbZhbBfICrd+bMOb0s1
X-Gm-Gg: AfdE7cnYcM3DNeO3R3vZJbqE8m+mJfMO9EgBsIyYPm7kEVYMGX8RKltki4E77CSecj2
	SlzLWQsxcUgw63+QjdS0J5yChgaEQS8aH2beGg34VDBuZJwG1rx0A8tkTWS8VnMrg9LpUxdG1Sz
	Wk7jZUrXpsokBftdZGH2qJ0ns/8qNrqr7z52LOLltfoZEb0BsD1eGTIw79726jLui2ergX26Gtq
	Enu7Z0Duw1hDbGkV9ZmZqtE1D8IywBt10ykYD8fPEnrvjoVz+T5Aw6yuTCyVDXoJITjPJs+U9/X
	4oF5XDtK2XQ10pBMB2Lg2KaSVGYa
X-Received: by 2002:a17:902:f60a:b0:2c9:cf5d:d9b8 with SMTP id
 d9443c01a7336-2ccea45e5damr36563195ad.33.1783534430021; Wed, 08 Jul 2026
 11:13:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260706232850.3333016-1-xmei5@asu.edu> <ak44aLdDrMZXb6fC@strlen.de>
In-Reply-To: <ak44aLdDrMZXb6fC@strlen.de>
From: Xiang Mei <xmei5@asu.edu>
Date: Wed, 8 Jul 2026 11:13:37 -0700
X-Gm-Features: AVVi8Ccu6snYjdggb6FSCQxgs0Bqzpz8sfbT4KG_8j_8JgBoMUD0oIr2n4336iA
Message-ID: <CAPpSM+RV+94_tvtX0EF=beC0AeNL0H2kTjtLt1c4fv3ddy4H3Q@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: bridge: fix stale prevhdr pointer in br_ip6_fragment()
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	AutonomousCodeSecurity@microsoft.com, tgopinath@linux.microsoft.com, 
	kys@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 4:46=E2=80=AFAM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Xiang Mei (Microsoft) <xmei5@asu.edu> wrote:
> > br_ip6_fragment() gets prevhdr, a pointer into the skb head, from
> > ip6_find_1stfragopt(), then calls skb_checksum_help().  For a cloned sk=
b
> > skb_checksum_help() reallocates the head via pskb_expand_head(), leavin=
g
> > prevhdr dangling.  It is later dereferenced in ip6_frag_next(), causing=
 a
> > use-after-free write.
> >
> > Re-find prevhdr after skb_checksum_help() so it points into the current
> > head.
> >
> >   BUG: KASAN: slab-use-after-free in ip6_frag_next (net/ipv6/ip6_output=
.c:857)
> >   Write of size 1 at addr ffff888013ff5016 by task exploit/141
> >   Call Trace:
> >    ...
> >    kasan_report (mm/kasan/report.c:595)
> >    ip6_frag_next (net/ipv6/ip6_output.c:857)
> >    br_ip6_fragment (net/ipv6/netfilter.c:212)
> >    nf_ct_bridge_post (net/bridge/netfilter/nf_conntrack_bridge.c:407)
> >    nf_hook_slow (net/netfilter/core.c:619)
> >    br_forward_finish (net/bridge/br_forward.c:66)
> >    __br_forward (net/bridge/br_forward.c:115)
> >    maybe_deliver (net/bridge/br_forward.c:191)
> >    br_flood (net/bridge/br_forward.c:245)
> >    br_handle_frame_finish (net/bridge/br_input.c:229)
> >    br_handle_frame (net/bridge/br_input.c:442)
> >    ...
> >    packet_sendmsg (net/packet/af_packet.c:3114)
> >    ...
> >    do_syscall_64 (arch/x86/entry/syscall_64.c:94)
> >    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
> >   Kernel panic - not syncing: Fatal exception in interrupt
> >
> > Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for I=
Pv6")
> > Reported-by: AutonomousCodeSecurity@microsoft.com
> > Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
> > ---
> >  net/ipv6/netfilter.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
> > index 6d80f85e55fa..547879da9532 100644
> > --- a/net/ipv6/netfilter.c
> > +++ b/net/ipv6/netfilter.c
> > @@ -147,6 +147,10 @@ int br_ip6_fragment(struct net *net, struct sock *=
sk, struct sk_buff *skb,
> >           (err =3D skb_checksum_help(skb)))
> >               goto blackhole;
> >
> > +     err =3D ip6_find_1stfragopt(skb, &prevhdr);
> > +     if (err < 0)
> > +             goto blackhole;
>
> Would you mind sending a v2 that solves this the same way that it was
> fixed in ipv6 output engine?
>

Thanks for pointing me to the better fix. We have tested v2 on the poc
and sent v2.

Xiang
> See
> ef0efcd3bd3f ("ipv6: Fix dangling pointer when ipv6 fragment")
>
> Thanks!
