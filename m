Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D163D376BD0
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 20:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775076070; cv=pass; b=q8H5rXqzGSNgj9aKKTQb5nREjbf/JAsOLzyWJx3uQ+urqJAmzfK2/oJsID2oi0drVhbKZC3yuDsau3IU5b1s/BToIS5OyaCCcth9L1fM4k1D2rBxH4+KMDEdjGs6hxG7EMzKxYQN3jYizE3pAPc0eFCV3K2+Gvfs9Iy5eACHjTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775076070; c=relaxed/simple;
	bh=z94+ohkVsVxUyep1qRj19M46dqyZ6y+PuOLQwmnDEDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rtuFxbQGIU/xwSLKA7XzT//l70YC9r9/J0iMG90frMNDvWHNRvKp1qiecF/yiQy89BOpKfkoLFpgZmlxeEz/yKix/JtX3RV7N6f9KjDp3SchfczaGqJDrO5lyXOz+iq9scMxgRR5kvE39wjJe6V6CSon1ENwlI/+XCBsVdQFTIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=CR2tPumz; arc=pass smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="CR2tPumz"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35d9923eec5so70425a91.2
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 13:41:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775076067; cv=none;
        d=google.com; s=arc-20240605;
        b=XsRAKzZSgNWFJHHgVgTYW4ms9w2heuONoafPkpb/PjYHlT4UTmKtNc7wZpFFOusCn7
         st+NF6+etsgvfq/ME/eYr/64KyDSpoTi7tR1qkfs9d1ZgNlnyWZh64xAIV+IPU5bTo4d
         ue870m9F5ddcafWdqIO1fEubLpqrbd1s+EhWqCuo94xcu0EdrFWAa8FOdOQZjbJvzXJg
         dVf3ifqgHj5ra/jVUhWhK/tSR3FHTLNq+jjXsoar6g+2kj+B9pcYMAT7O4GJeBy6valY
         kW1KPlTTBee5dpyGHYggyzZ4RqSPaerx27rn9IVLyc6dAUf0fsCcmvoWt8Ubx0ufwKV2
         kXpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KijIFQe0NqqeKl69HCXypV3vUYAKuByHe78TDARydIY=;
        fh=9VnT9UT05f4NsznhxoPHGUikowchNZvVQ55Onb1xLxU=;
        b=PRCPBl+Mapvjeed3sR0Z7TaaU6kwgJIfbQddh0F2LLtEgvucoMZ7FEKuX5yVnx7IyT
         9Gl7AUqOLlE1TPVWt4wAYm878QsoAVV4SSoo0LoS39VSp31aWr6QUjk3VWZzSLU93i9k
         E9HPUv6l1mQsRy/2f66rphK2VbPNyv64CxHJSH1fE8x+258fbnrEtYv2EvbPbUR4580c
         ZWqO345tBMTzSBvc4m3QsZ778Ma8uZG6NBPRrKt0+F24Kgc6FzYjASNuV2V7WVupC4Ur
         Tnn+xQet3tTOaUkrpi3gjiAu1BU5omIOD+WDFD6KyURt9AtDXF+VpmgwBFiSBPQrtcf1
         U/aA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1775076067; x=1775680867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KijIFQe0NqqeKl69HCXypV3vUYAKuByHe78TDARydIY=;
        b=CR2tPumzdkXJ16Ay4LC8b6tb+kofbtVpbJGZ957Ivlg9ei7WwcRIYiQZxSRI2DeYKV
         85wSUemEBYfi6kahngaNtoLKHsjIUJ25jFBWWPU23Ux/wvzjm2uNtMZoBY7+GCDzheaX
         Rk0R4VUBTc63DrSB50iaBWvdzVVtPSg8e67Umgn4oik4SKnTbnSjiv0cV4K6YogGLBQ3
         vJCYSc2p0j/2NdYNq3I1KY8OSDfQz8lrqYIf/i3J8NKGdXJtgl9buhIqTrkSC1qY2jVx
         OBi4KjQYPf8N5BNJbGjAURKyrRT8Hq9fSlqHkUEWe4OAQQPt9AmPuFt17c5pnvpsMSwP
         TqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775076067; x=1775680867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KijIFQe0NqqeKl69HCXypV3vUYAKuByHe78TDARydIY=;
        b=BcZxhOZjk/t5hJ7TXpoFEaxStKhExGlKkH00w5x+BzMz+gtdM2+utOBuooLx7i1u8u
         p8NaFftHOsx9y3DqzW/TnnK98zodPzS0b8JdQeIxggA/A78xwvw5d0pegRn9xsPmYddk
         D85/rN7t1lNc5Rl3YAvJfNAmXCJmXum6oBz3oErkUYXQ0hEkV6ZWYSfub6klBCwwCQk1
         LA6fr1SFGyOgPUB1H+r7JjE0rgPJGskuH+DNbEIKnuibZGOfD4iS6FnajtF8FxogGlJR
         XmG8ZwPZ7LAqQQquUI9SYaWbhSCfEqKl4wv/KJ8ZDERqxfyGQLczTF5uyTK7CGmJvOBK
         hIRg==
X-Gm-Message-State: AOJu0YzV7qFPCkPHxKZ6X087xkXWNrGNVf2LcV+CScwNY7mhR9/zMQVS
	ppOtrb3xUoAD6UYRhk6sKhb8cOd7h+pV/pDCU8VQm2hx6I8A4L32JjjkxnC9gcbi9x+KAUG5qEW
	XFIShRwi8MoqUlNXL6MXk65Qp+BMK/CC9td7pKdtD
X-Gm-Gg: ATEYQzz4iQGUtg4nZuszhTkYQXNZ0K20yvQ1r8e1OJ6pJfodSiZHKSXET3eVDX6d49A
	3pyUqR4P9FmiNVqn1WCkpm6bhdcLnVJOtmIf5nKbXG6FOQ3GGSN/cqOs3Pej+CFSLAqQ1PPG36d
	zYXQhRhHe34hCVAMpMHDf9BDPcRvuegwzLAfMoZNnQivFZCdq3aV1x8A7wDYW0CYuad2oZNyXeQ
	rfTN3/+R+eIyzjLvU/f3mlbw6myure6MiIRt3BuuF0s7z6wRjCuF46Pwsl9cdLxaeeEv1As5VRR
	R+tNMmVN
X-Received: by 2002:a17:90b:3f90:b0:35b:9ab6:1d4a with SMTP id
 98e67ed59e1d1-35dc6edc398mr4533888a91.18.1775076067232; Wed, 01 Apr 2026
 13:41:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260401195735.564488-1-xmei5@asu.edu> <ac2Ce-hHidTY8Z6V@strlen.de>
In-Reply-To: <ac2Ce-hHidTY8Z6V@strlen.de>
From: Xiang Mei <xmei5@asu.edu>
Date: Wed, 1 Apr 2026 13:40:56 -0700
X-Gm-Features: AQROBzCEzF8ToAv3_cJAUvbyWqTP6wVFWJTiej9ApJ7ZMVfa7_KDYNu0viJXQsg
Message-ID: <CAPpSM+StQs6poh21nz5qTG0-QpRHi0S5RO=AM5gQOfd8rOAVWQ@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: nfnetlink_log: initialize nfgenmsg in
 NLMSG_DONE terminator
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc, 
	davem@davemloft.net, eric@inl.fr, coreteam@netfilter.org, 
	netdev@vger.kernel.org, bestswngs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the suggestion. I'll send a v2 with nfnl_msg_put.

On Wed, Apr 1, 2026 at 1:39=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Xiang Mei <xmei5@asu.edu> wrote:
> > When batching multiple NFLOG messages (inst->qlen > 1), __nfulnl_send()
> > appends an NLMSG_DONE terminator with sizeof(struct nfgenmsg) payload v=
ia
> > nlmsg_put(), but never initializes the nfgenmsg bytes. The nlmsg_put()
> > helper only zeroes alignment padding after the payload, not the payload
> > itself, so four bytes of stale kernel heap data are leaked to userspace
> > in the NLMSG_DONE message body.
> >
> > Initialize the nfgenmsg struct after nlmsg_put(), consistent with how
> > __build_packet_message() populates nfgenmsg for regular NFULNL_MSG_PACK=
ET
> > messages, to prevent leaking kernel heap data to userspace.
> >
> > Fixes: 29c5d4afba51 ("[NETFILTER]: nfnetlink_log: fix sending of multip=
art messages")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> > ---
> >  net/netfilter/nfnetlink_log.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_lo=
g.c
> > index fcbe54940b2e..ad4eaf27590e 100644
> > --- a/net/netfilter/nfnetlink_log.c
> > +++ b/net/netfilter/nfnetlink_log.c
> > @@ -361,6 +361,7 @@ static void
> >  __nfulnl_send(struct nfulnl_instance *inst)
> >  {
> >       if (inst->qlen > 1) {
> > +             struct nfgenmsg *nfmsg;
> >               struct nlmsghdr *nlh =3D nlmsg_put(inst->skb, 0, 0,
> >                                                NLMSG_DONE,
> >                                                sizeof(struct nfgenmsg),
>
> Would you mind sending a v2 that replaces nlmsg_put with nfnl_msg_put() ?
>
> We already use this helper in __build_packet_message() and it takes
> care of initialising the nfgenmsg.
