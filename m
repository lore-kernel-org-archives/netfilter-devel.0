Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BC9205E18
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Apr 2024 18:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713637943; cv=none; b=RMlDmPU2OxA8BcXTqrstwd7oOgfTfEPFlrpuKiTwnk40L4X6gL6/j7521YLmMFMzLLI37esD8AQ1c7ThgAaKiMaQ/kfO6qh1w9JmgSn99XP0xeWhPKfrkTcqGLSTRMsgSKZfqjTxWpi2mgShQmYeoneALn7z7FXpiyZzSRZYBdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713637943; c=relaxed/simple;
	bh=1ckHfXu0IC5drOUZ2Af6tqqhTg5RGDdXibtM+LP+oNA=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VKKZhXYCKD0C0Kp5pzMW9vQDLHOSgxt3gTus/kqri1Wrs8FU+cAfAjNOkbVSaIkjamGMUAsiG3yfQqi69chk0ANPkdzOdYA5vWcA0g1jiehPiJkzQdWN0dKH0XNl1aihxhoPJI64Its+510CIXkyyWtBBJ4BtnvHtjxVsAL+zIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GEqQwEnZ; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEqQwEnZ"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6962a97752eso26735456d6.2
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Apr 2024 11:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713637941; x=1714242741; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j15fgyhZJGUf1oQfaBOxkroa8xNFtil3BVxxl5Jn2OM=;
        b=GEqQwEnZue4p2+/5zO9xL6QTcNPAE1rCbPGHlBsbzCASRdpdBM6QdN7zlqBKwxvCLV
         HAVWdbPpb1A2lIMf52waq/zt6HL0+S+TAkbm59dUz0mLzi8HVujLR5JlCFY5TwIvwFQU
         wkDLO0189aUX5P7dZJ24LBqfs7JCOjSxkExJQ++s6lRfHzUGplXfu5TKOt6Pi43H0/Wt
         7S28hHqsSmHUDh6MZuj3mleZW1BDp/mhzT1/n+5SWTBZpQr2P5WccmeutlOg0x/NfGCR
         fq7h7y8XJy4tgTVDIsaSvuNhulEaF/wCMW2+KEILef/FRb/Rnbskm56atJz1k9AiaxQA
         16Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713637941; x=1714242741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j15fgyhZJGUf1oQfaBOxkroa8xNFtil3BVxxl5Jn2OM=;
        b=r1YrTJNdZKrg1YaZSs14S0RpD4g9e6jnH1OcXJL9yvD/Boo/oq3TtAgvOFXqBQQrjv
         o38nbzW5Jv7s+dy6uN2R3h24NKC8sgLVztailXRoUUG2y832NlQdZq2UUuaxUr3kgA6O
         kgl4ZlrWMRk9IJeC4od5Nr+UpA0oYHzjCoUrB7jegAteTMsnr0YDqo9VtgYmTIS6ayvJ
         jZBO1F4/VD/Ab6o2Z6Ne8GvajBFVTInrtHDBBcw5ilMdKPXtOe/5VS9jWGnvVCQZ9EdE
         +QA44l9/KuAZS0Gw2Jd3AsxbS2KqG7/vA4MMlCaDrqGUwN+0And/3/UqbjvNwwzCFLTY
         25yA==
X-Gm-Message-State: AOJu0YzWgpW9JXX48VRI8IduwD8CiJdvTy9qe4eZpCu0kHVN93lF+0om
	uM+4tv1MUl8iW1NWCMKdn+6gqrIkBnvlle/S2Q+O378FbsHC1SsM4uMo+upa
X-Google-Smtp-Source: AGHT+IGHnIqUdF1aWODQt3Fm0jU2+qwGiDIoPy5XpY3W/hAlfDO4rIKOVvihiD6rIE1C2/goHoTFqQ==
X-Received: by 2002:a05:6214:10cc:b0:69b:2521:fcfb with SMTP id r12-20020a05621410cc00b0069b2521fcfbmr5429046qvs.53.1713637940953;
        Sat, 20 Apr 2024 11:32:20 -0700 (PDT)
Received: from playground ([204.111.226.63])
        by smtp.gmail.com with ESMTPSA id z15-20020a0cf00f000000b0069942e76d99sm2669129qvk.48.2024.04.20.11.32.20
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Apr 2024 11:32:20 -0700 (PDT)
Date: Sat, 20 Apr 2024 14:32:18 -0400
From: <imnozi@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: Re: [Thread split] nftables rule optimization - dropping invalid in
 ingress?
Message-ID: <20240420143218.085d31a5@playground>
In-Reply-To: <20240420084802.6ff973cf@localhost>
References: <20240420084802.6ff973cf@localhost>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 20 Apr 2024 08:48:02 -0000
"William N." <netfilter@riseup.net> wrote:

> As per advice by Kerin Millar, this is a continuation of another
> discussion [1] which resulted in a different topic.
> 
> On Sat, 20 Apr 2024 03:36:00 +0100 Kerin Millar wrote:
> 
> > To begin with, I would recommend that you jettison these rules
> > outright. It is probable that they would otherwise end up being
> > useless. But why? [...]  
> 
> Actually, I have read about all this in older posts here. I should have
> probably clarified better the forest, not just the trees.
> 
> The rules I mention (along with a few others) were inspired by a few
> sources - some using iptables (where INVALID may be different in its
> code definition from nftables and thus need such rules). That said, I
> have actually tested and am aware that e.g. Xmas is an invalid TCP
> packet that will be dropped by conntrack anyway. Similarly, the others
> too.
> 
> However, in the setup I am trying to implement, I am attempting to be
> "clever" and optimize things by dropping bad traffic earlier, so I am
> doing it in the ingress hook where, AFAICS, conntrack is not available.
> Why ingress? - Because I am following the general principle that
> attacks should be stopped as soon and as far as possible, rather than
> allowing them go further inside (in this case - next hooks). And even
> though the next hook (prerouting) can drop e.g. Xmas of FINSYN as
> invalid, I assume it would be a waste of CPU cycles to allow further
> processing of such traffic. So, I thought: why not prevent the
> unnecessary load on stateful conntrack? - Hence the whole idea to drop
> early.
> 
> OTOH, adding more rules to ingress adds CPU cycles itself.
> 
> Which is more optimal - dropping early or not piling up extra rules in
> ingress? Looking for an answer to that, I have done this:

INVALID packets are those that netfilter has no idea what to do with and will eventually drop them after they fit no existing ACCEPT rules. A couple examples of INVALID packets would be (1) a TCP RESET for a non-existent conn (possibly one that was just reset, possibly a DoS attack), and (2) a TCP data packet for a non-existent conn. Neither of these is routable because there is no place to send them. Thus they are dropped in due time. The choice is whether to drop them after they pass through all the rules they will pass through or to drop them as soon as possible after conntrack tags them as INVALID.

With iptables, I found the earliest I could drop bad traffic (large blocksets of addrs I never want access to or from whether or not they are INVALID, and all other INVALID packets) was at the top of PREROUTING in table mangle. I would think nftables is similar.

The most optimal involves the least amount of processing. I would think conntrack is more efficient at tagging INVALID packets than a bunch of rules somewhere. Then it takes only one rule to drop INVALID packets early in PREROUTING. Or two if you jump to a chain that has a DROP rule; said chain would allow you to easily add or remove a log rule.

Neal


> 
> As per earlier advise from you in a different context, I checked this:
> 
> # zgrep BPFILTER /proc/config.gz 
> # CONFIG_BPFILTER is not set
> 
> If I am reading this correctly, it means there is no BPF JIT
> optimization. Is this normal? Is BPF still experimental and for that
> reason not available? I don't know, which is why I asked and still hope
> for an answer:
> 
> https://marc.info/?l=netfilter&m=171345423924347&w=2
> 
> Why am I referring to BPF? - Because I suppose having it available
> would make the difference between the "drop early" (in ingress) and
> "drop as invalid" (in prerouting) cases negligible.
> 
> Now, the question comes down to: How big is the actual difference? Is
> it negligible right now (without BPF)? - I really don't know. Hence
> this other thread:
> 
> https://marc.info/?l=netfilter&m=171354240711565&w=2
> 
> Any info and advice is very welcome, as the whole thing discussed here
> is very unclear to me.
> 
> --
> 
> [1] https://marc.info/?l=netfilter&m=171358042732609&w=2
> 

