Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053CF190688;
	Fri,  7 Jun 2024 14:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717769630; cv=none; b=mRolFK4Z/en2s3aQ2ouFQoYIMj7c59P8BnMndBaWtyFlTgFNVr5klbj3+FCTKp1e1CoPZLtMU3N0E5+jmDp+UrYsF0lRfQeoO+Gm9vOViE0VRRKrf44BwlTLRNmZBMOUuKykWebKA+rEutxBeoTjuA5A8kMxCm/NI3Ey4lI1bOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717769630; c=relaxed/simple;
	bh=h8SrABv9xVI5t/A44n3g7COQPE+D88GaCDSSoBXDB7E=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=AxVXO6Ceh2uLY34i5B66SPry4GYmnoskLPdN1Y+nPN3CIteFJz2voPueRycjPd0v+SU8c1BjUa4Q1F1FlMfpC4rD1/lOhkIeSamYg9bGZbmXV2BN8ZNLkU4CSMV46TBj/f0JpJnM4VvdIyP65MTggaG8jr6Wrc66OUPlwIitYok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mkixJhhA; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mkixJhhA"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6af6c2bee7bso18367956d6.1;
        Fri, 07 Jun 2024 07:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717769628; x=1718374428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olAsbRmHjvUjtmdGZKqQHlFuLVWJli5njLF2mZn8TUY=;
        b=mkixJhhAuAjbmEeF8reU61EEX0YO2I5t1ZUbVWZoK3quzBI8ttj9oGjlS3YRppoQA5
         yV5+iO1f10nVfN7KAJDow9d1njuDfB7g+n6l4wSc7uFzz7Q7c6wrRaq8uYaxXVyjKF21
         1t9v2aComC3TVJxCYA/d0SVyr+fhJmGHg5nHtypKQJTurra67e/Ck+xo4nQBPjF7zBV0
         upPvM2yf5AVXnou9/HZvRGPVH+f/FZ57KNaMayzy4AWqFQk+tSfHYj4xFgkvDwvoirK1
         FW8CvefqOBVo9nmLGgvm6e4tpmhTtRPGLb+4dx/jfdPywRNOwpADRv2zYRDclvzSAPZR
         PY/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717769628; x=1718374428;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=olAsbRmHjvUjtmdGZKqQHlFuLVWJli5njLF2mZn8TUY=;
        b=WUKsD5kuyW6/WAsSzBkLH5zyQwd0dry4Gyk5seKg7vUpO7EfUvQLAmZO/EsfCEblCD
         SilC9zmnBYgl3gxoFqSRXb9bg1xXBBq3/1QrCmhcinMMrM9HsA4sk0YPUCXqCsbr0O2i
         RhxsmfaDsjaHXp0IzMSdb3bQTRT32r3LZrlscpM2lVRFg4BjBtN/LiCK2GpzXDwVJGu8
         PqZ0Dnjk28ARf2Z3AUEJG6qdM8orAepr0v5r8MPCGA8nCRaxztbr29H2Fo0/18SZ4lte
         oWT6E7QsC3px9xs8B7iUddOf6dfaowLmzoU8nMfqqTGmGHkZGz6l5QfUwcT2Yo/0+P+S
         MAXw==
X-Forwarded-Encrypted: i=1; AJvYcCVDuqWEC/z/rI8IMMoHUSQTva+HnTaR/MNNVpWVHA1KgiTQPoZKzIornzSAMvpKJguvzdeWIjiCOWBiFT6nH0fiqUHTnmmExXNXrh7BQ98Z
X-Gm-Message-State: AOJu0YzGMJefZ/sjYa6H8Uj+99Xqd9LzP00P6p08BzVtsrNL800m/86i
	YJFvGwJ08hO19XKu+7wLZLGUrNbQbG0jj1rf4IfZmt4pKMbECMVg
X-Google-Smtp-Source: AGHT+IHr+PCcf1WkuVzRWZucQTdIiQWwssQMae51/dgnX/y44swIrbFN5XvVxZvM6Sfsy5ktQ0uSgw==
X-Received: by 2002:ad4:5763:0:b0:6af:4fcd:3065 with SMTP id 6a1803df08f44-6b04c059731mr121148846d6.19.1717769627606;
        Fri, 07 Jun 2024 07:13:47 -0700 (PDT)
Received: from localhost (56.148.86.34.bc.googleusercontent.com. [34.86.148.56])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b04fa2937esm17135446d6.140.2024.06.07.07.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jun 2024 07:13:47 -0700 (PDT)
Date: Fri, 07 Jun 2024 10:13:46 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Eric Dumazet <edumazet@google.com>, 
 Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, 
 Paolo Abeni <pabeni@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 netfilter-devel@vger.kernel.org, 
 pablo@netfilter.org, 
 willemb@google.com, 
 Christoph Paasch <cpaasch@apple.com>
Message-ID: <6663159ab88ef_2f27b294c5@willemb.c.googlers.com.notmuch>
In-Reply-To: <CANn89i+50SE0Lnbpj1b1u62CyOfVxH25bneXnc3e=RJB0+jJ9g@mail.gmail.com>
References: <20240607083205.3000-1-fw@strlen.de>
 <20240607083205.3000-2-fw@strlen.de>
 <CANn89i+50SE0Lnbpj1b1u62CyOfVxH25bneXnc3e=RJB0+jJ9g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: add and use skb_get_hash_net
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Eric Dumazet wrote:
> On Fri, Jun 7, 2024 at 10:36=E2=80=AFAM Florian Westphal <fw@strlen.de>=
 wrote:
> >
> > Years ago flow dissector gained ability to delegate flow dissection
> > to a bpf program, scoped per netns.
> >
> > Unfortunately, skb_get_hash() only gets an sk_buff argument instead
> > of both net+skb.  This means the flow dissector needs to obtain the
> > netns pointer from somewhere else.
> >
> > The netns is derived from skb->dev, and if that is not available, fro=
m
> > skb->sk.  If neither is set, we hit a (benign) WARN_ON_ONCE().
> >
> > Trying both dev and sk covers most cases, but not all, as recently
> > reported by Christoph Paasch.
> >
> > In case of nf-generated tcp reset, both sk and dev are NULL:
> >
> > WARNING: .. net/core/flow_dissector.c:1104
> >  skb_flow_dissect_flow_keys include/linux/skbuff.h:1536 [inline]
> >  skb_get_hash include/linux/skbuff.h:1578 [inline]
> >  nft_trace_init+0x7d/0x120 net/netfilter/nf_tables_trace.c:320
> >  nft_do_chain+0xb26/0xb90 net/netfilter/nf_tables_core.c:268
> >  nft_do_chain_ipv4+0x7a/0xa0 net/netfilter/nft_chain_filter.c:23
> >  nf_hook_slow+0x57/0x160 net/netfilter/core.c:626
> >  __ip_local_out+0x21d/0x260 net/ipv4/ip_output.c:118
> >  ip_local_out+0x26/0x1e0 net/ipv4/ip_output.c:127
> >  nf_send_reset+0x58c/0x700 net/ipv4/netfilter/nf_reject_ipv4.c:308
> >  nft_reject_ipv4_eval+0x53/0x90 net/ipv4/netfilter/nft_reject_ipv4.c:=
30
> >  [..]
> >
> > syzkaller did something like this:
> > table inet filter {
> >   chain input {
> >     type filter hook input priority filter; policy accept;
> >     meta nftrace set 1                  # calls skb_get_hash
> >     tcp dport 42 reject with tcp reset  # emits skb with NULL skb dev=
/sk
> >    }
> >    chain output {
> >     type filter hook output priority filter; policy accept;
> >     # empty chain is enough
> >    }
> > }
> >
> > ... then sends a tcp packet to port 42.
> >
> > Initial attempt to simply set skb->dev from nf_reject_ipv4 doesn't co=
ver
> > all cases: skbs generated via ipv4 igmp_send_report trigger similar s=
plat.

Does this mean we have more non-nf callsites to convert?

> >
> > Moreover, Pablo Neira found that nft_hash.c uses __skb_get_hash_symme=
tric()
> > which would trigger same warn splat for such skbs.
> >
> > Lets allow callers to pass the current netns explicitly.
> > The nf_trace infrastructure is adjusted to use the new helper.
> >
> > __skb_get_hash_symmetric is handled in the next patch.
> >
> > Reported-by: Christoph Paasch <cpaasch@apple.com>
> > Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/494
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> =

> Nice, I had an internal syzbot report about the same issue.
> =

> Reviewed-by: Eric Dumazet <edumazet@google.com>

Subject to the documentation warning from the bot

Reviewed-by: Willem de Bruijn <willemb@google.com>

Thanks for fixing this, Florian.

