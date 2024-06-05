Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0680715FCF1
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2024 21:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717623523; cv=none; b=VZY+BazbUwbMl7zwdytfSLMXzSQHGcVcHRsjhMBPN7jrDck3li4akNSi4ECVjNNc9umzfKixoNlORgSe0dn86MbiYmUP1fGtjgxfkt/cfttdx96qA+4NhAbfmcPXWs8rsDi53TA2d3yWe5eXzZNAr40PQEy1OJEiwQT28yGSwgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717623523; c=relaxed/simple;
	bh=iFkPUwycPtMXY95Fsn6h0Cq5+b23g0Zkpwj3cwixKS8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ujpRJAZy6joXlpg8gIuyZV4WsF0ZKCmFz4pV2s5GvgY3FBBVgwhDTc8b4wY7v1zqQDEsfYRN0ERwY5XB1djdLhiQbN2cNclDjc3nAdnfFWVTzuLAo8uGBSZOnji3NzAFEwqfZM+1UzhYeyV9LlIAZOYSx9ALqeQZP9pubAzV/E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mamKSLgt; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mamKSLgt"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4400cc0dad1so132031cf.0
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Jun 2024 14:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717623521; x=1718228321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNlsexQwemrp3YanWDx0EtmNkeLt675d7VKIepxZtwQ=;
        b=mamKSLgtkGbxm/tSXVd7DRkaHPVAsKAEa62DE5FZ2fSTTFR7Cb3/i/Dav1udik/pye
         ZAnfnS2CXmyWOeA/fLaowo74MPoyGxdVNF5rBc18wFGjWUqmj2zL4N4XpbKjt5ekuTun
         N5xW0KbZpOgVJC4xjK2doYvOLsquo/tTwT/k01jhZxTb/FbZZ+QoL3k7X+T/XDPI8k2t
         XU99rbF8tygpo8i/d+rCWUjNIyvlmY4xu2ObdIyfW50HDd76ZyVmM0sXRCUTqXuDOp/G
         YHbdHxaRMnESNczF7PC+fiW1rYHknkvhFxmXUqxQaQhTNblrm3epY150Tdmgr7Qig97I
         WIGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717623521; x=1718228321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sNlsexQwemrp3YanWDx0EtmNkeLt675d7VKIepxZtwQ=;
        b=t1NrYPahlYfsT6uRWlZsKUqhopBhQ/xUEhfpbZxl9l7M0yhA1T0EHCK6CfMVdhd+l2
         ZfPBd3Ho1AwubZVfdHQYO368b6lyW8XmM1NhLeKxmzC9qM4uexZUKrdnYLIh5Us6YZrn
         EhqNp3Oh44EPuuAmJk897Pgrt9zZ6+9UGYTC2V4M4zdgNMiJyZeeAILLwOVK1fGmL7XD
         j8NNRY8USchbg/YVDHhPc/YwcsMXpuIM/JRk+yHEYLUFb4Irg9d7a0Il+4hHk4xzcaoM
         IXAv60lESAZTk8j6SNb/mW61c/7xlvVaVrQvayNJNZ4JRDh1YAChSihFcMZG6l0xSc9Q
         z5Nw==
X-Forwarded-Encrypted: i=1; AJvYcCWDIO3ch1ETs20S1VR2rY8enXv47zmGyN2kJjQMHIWzcUv/ycJgmLTUFrziJlY45q3YbiD+0Mx/erJooqCpWjuwb/DFASyBsZSmhBp9OISe
X-Gm-Message-State: AOJu0Yw+ObMjoy8DjEfYYcm4Tv/DXTulUiUV/oInBNEt/ryAsu2RVZtu
	kBsh0DkHo2StHUmirgT5POQln8Yh516rFGWTB9t4g5fI1WcA+wGF39GnPk/klC4smRZO/JXif+W
	mot3BLgmYHjeYj+XBzNoM90uSBRdKgNiRIMff
X-Google-Smtp-Source: AGHT+IEiuKACUaGLuSwGmJwkpMR0OPVSW4SzM49ZaIPJxW507njKclILP9f6lCQlKpo1klduo2oOWGSfKnf+UaubKEY=
X-Received: by 2002:a05:622a:5a9b:b0:440:1451:d152 with SMTP id
 d75a77b69052e-4403730ebfamr1008921cf.28.1717623520568; Wed, 05 Jun 2024
 14:38:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240604120311.27300-1-fw@strlen.de> <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc> <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc> <ZmDAQ6r49kSgwaMm@calendula>
In-Reply-To: <ZmDAQ6r49kSgwaMm@calendula>
From: Willem de Bruijn <willemb@google.com>
Date: Wed, 5 Jun 2024 17:38:00 -0400
Message-ID: <CA+FuTSfAhHDedA68LOiiUpbBtQKV9E-W5o4TJibpCWokYii69A@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Christoph Paasch <cpaasch@apple.com>, 
	Netfilter <netfilter-devel@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	netdev@vger.kernel.org, daniel@iogearbox.net, 
	Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 5, 2024 at 3:45=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> On Wed, Jun 05, 2024 at 09:08:33PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > [ CC Willem ]
> >
> > > On Wed, Jun 05, 2024 at 08:14:50PM +0200, Florian Westphal wrote:
> > > > Christoph Paasch <cpaasch@apple.com> wrote:
> > > > > > Reported-by: Christoph Paasch <cpaasch@apple.com>
> > > > > > Suggested-by: Paolo Abeni <pabeni@redhat.com>
> > > > > > Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/=
494
> > > > > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > > >
> > > > > I just gave this one a shot in my syzkaller instances and am stil=
l hitting the issue.
> > > >
> > > > No, different bug, this patch is correct.
> > > >
> > > > I refuse to touch the flow dissector.
> > >
> > > I see callers of ip_local_out() in the tree which do not set skb->dev=
.
> > >
> > > I don't understand this:
> > >
> > > bool __skb_flow_dissect(const struct net *net,
> > >                         const struct sk_buff *skb,
> > >                         struct flow_dissector *flow_dissector,
> > >                         void *target_container, const void *data,
> > >                         __be16 proto, int nhoff, int hlen, unsigned i=
nt flags)
> > > {
> > > [...]
> > >         WARN_ON_ONCE(!net);
> > >         if (net) {
> > >
> > > it was added by 9b52e3f267a6 ("flow_dissector: handle no-skb use case=
")
> > >
> > > Is this WARN_ON_ONCE() bogus?
> >
> > When this was added (handle dissection from bpf prog, per netns), the c=
orrect
> > solution would have been to pass 'struct net' explicitly via skb_get_ha=
sh()
> > and all variants.  As that was likely deemed to be too much code churn =
it
> > tries to infer struct net via skb->{dev,sk}.

It has been a while, but I think we just did not anticipate skb's with
neither dev nor sk set.

Digging through the layers from skb_hash to __skb_flow_dissect
now, it does look impractical to add such an explicit API.

> > So there are several options here:
> > 1. remove the WARN_ON_ONCE and be done with it
> > 2. remove the WARN_ON_ONCE and pretend net was init_net
> > 3. also look at skb_dst(skb)->dev if skb->dev is unset, then back to 1)
> >    or 2)
> > 4. stop using skb_get_hash() from netfilter (but there are likely other
> >    callers that might hit this).
> > 5. fix up callers, one by one
> > 6. assign skb->dev inside netfilter if its unset

Is 6 a realistic option?

> >
> > 3 and 2 combined are probably going to be the least invasive.
> >
> > 5 might take some time, we now know two, namely tcp resets generated
> > from netfilter and igmp_send_report().  No idea if there are more.
>
> Quickly browsing, synproxy and tee also calls ip_local_out() too.
>
> icmp_send() which is used, eg. to send destination unreachable too to
> reset.

Since this uses ip_append_data the generated response should have
its skb->sk set.

> There is also __skb_get_hash_symmetric() that could hit this from
> nft_hash?
>
> No idea what more callers need to be adjusted to remove this splat,
> that was a cursory tree review.
>
> And ip_output() sets on skb->dev from postrouting path, then if
> callers are fixed, then skb->dev would be once then again from output pat=
h?
