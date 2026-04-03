Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD2C3CB2E1
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 15:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775231740; cv=pass; b=S5Wl3HjQr0ToP5UP3iGJKUMCvNutYrIjkBhdjwCj0VixLZgv+KVfAMw9opXVYLeG5kc3h79pOn5aGjGXS2zh5/3e/a2HIxKnDfSr7fzVBUzgMd+W6UD8bErVgcCKAlgdt3Ys9RIZ1eHHw/gjFE4onl92mmjcvAvgg7g2OiRfWaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775231740; c=relaxed/simple;
	bh=vvWbGlNi6TFlplucfWZOlihteJtMnLTcNCquKtF8bUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ngpSK200AfWjiqpKfFvQ+ycCbjHlY5skUtUgBKDbr09frzVZfpjMjmGZOHIx7n0N+FdAR2YxiXn/YS6Mv2FnI/ew4X9XBGqkwH6H3vRwjt6IrZ3Tx0gyQVcxfydo+4qF5Nvly/564yRENLUpoMKVOG+RMVlH+XqLus1/S0a4ZBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F11tEcvP; arc=pass smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F11tEcvP"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-953b9fd8ebdso1318507241.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Apr 2026 08:55:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775231738; cv=none;
        d=google.com; s=arc-20240605;
        b=FwWXuLy0AGGBIEvtJ68LaiNpx5qgUMqrEvyqYQJbYNOwFliu0jI25PIr9+wb7s61oA
         OwnOmgGBx24yqc+cPW/yh2pny0WVlEGMs/AJ1XGI6CuqQ26l7JarEL3Uo563Yj20rHgN
         AXGiEkt94zTX6xlgzK/k1dvsEstVRa1kap8/19VwDKDkIVzt2tgGg2QoHfXCB5q3yiqU
         tTmkRC+uccTM3PlXmXNNusUjYrYwvyTvBMaWDrs9unwHbLjPO2P6i07cEjlHwasyrXUQ
         1obMEZDygxTmKAvROivOshffzQMAPtzOF7qwVJ0o0/prXgY8SrONqY2aqPI9hhZiT6aq
         D/IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bSlULmnrafbTFmkOz05b2qK30GDxC9T/cfATlW/fQBg=;
        fh=n5dbouMqIJ5MdRme7pWNhtW7d6Cas+P+7EHDjxWUlbg=;
        b=YTujGcv2KxdCtv6/yvtwyK8O9MgoPcq32ip5aqDT9++dwiGXSuVAMQn8yPkia8K+4D
         1KkF96ZXBOsQmLsCc5VLedMtu/eGhwjaSU0L34S2kP4cS5UgbI10Gb0qvkNR7v3ARx8Z
         1kGW2xGwboPZA3WiQ28UzXIbaoYkN5z2pBBr3UY6cvlvkV6nGnYmebzAYDXI95n7XCJV
         J1RvrW6BF1p2pMNjdhj5JCWNVRBCWstY99JuFaIQ4PQ9eQv9Q/ANRgIgD4+9IrE2elp2
         bGpajl0gveBaX54jfkxckGkRFBwQEAAq/A2yqEKdHtGDasVU+dp2S5UC2/kmqS++Pm7e
         beMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775231738; x=1775836538; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bSlULmnrafbTFmkOz05b2qK30GDxC9T/cfATlW/fQBg=;
        b=F11tEcvPgqKYb4KPaaxtaHz3a+/FG9H+7KF3zMtysUDl+QqDCj8NDdfo7HDVjEQWQD
         qjWK7b3ASXW4y7mkbFYc2KjDoxGE5JJE8LQz4YMAlTgNdCf741vK8AcMzTlisf+Cq1Ze
         onMNXEXJTvJP/apFU3SJ4x1CX43iWesyQcXBlJ/oRdqvFtjeMUWjZEuUESQvfQHOYjHc
         XtHk7425VGN3jbe2a75NNatKsJC2LhrbfybRuz8w2W670txaLoOrlqCTbfRW9++jbFux
         7rmqCTfR+LzPyVyBp81XLiexTZ3E5aC0oTap28BYYvlIKLDy6KmsXPvpBZTg/yPf9lAd
         MBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775231738; x=1775836538;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSlULmnrafbTFmkOz05b2qK30GDxC9T/cfATlW/fQBg=;
        b=htcmbxBuIRohSzFpxcbysV52ryugoLZn8LHmVGAdDHEJaBh8JyDaYpQ0T8Flr2aQp/
         xbo1u7pCAHAHknufd0qrfdcVbEbHLBCBn5Os3xg1lCgr4BSvw9Y+w9bHgY+4pUNAY+EC
         tfRLr8mrTAcnOse3Am+Dc6fDS1g0LfqZt8Jjbs+MFBDEsIGOEvs90TcDMJ6OmQ+fMdNn
         KJZ2O0parhzBo1w748pse2PVczEjnr3YAtApLvTWhBH9dLKiDDi/bdBMwW6n6SDenm7w
         zHICjjpphRQK3l2ou8azvtWN401z9BJe3NGmMBp/ManAC5zrCNbReixgaii7JWvrapaC
         68yQ==
X-Gm-Message-State: AOJu0Yzt4uENw6oHP8Wnqbq3X/FzNWUGSXzB/B69alsAyZ226cuWec7B
	Z/R4wRYs8GaB2hM2EJys6vcO/ABg3ubdlwGh3t2ZAEdGc0TAJCSYawbbEM82kNN7dHTlKQvHVg8
	/kEwk8e6inIRS9aM9c3wYN9e71fRRvQij/XP7
X-Gm-Gg: AeBDietib4ck44MwfJ7KRwtt72KVhoruvvHRmwTy0kD0nYv+QEAvVbZMnL5FY9dr3dN
	1E6SS0NlkK+zS2XpV7NT7NrOLmbBg0CXKkO0jx+sVfM2EC1nDOkvNykzKG/+9tB1gl2SP/LdR0j
	Uh31S3bOz979eQxLCeoRiZ9GR5uUwznRAWO9gK5WB7BZrdo5wPTpwakiLjOILdDWnWd/dp1R7Yk
	lFi5zwlQUz0PZ94rhmt6pzFxb011Vuxjs0/8Gfu0E1MfKPtZ3NLuHlZoUS/vesIyWB9Vy9z3vK2
	tPWqHqE=
X-Received: by 2002:a05:6102:358d:b0:5ff:be25:894a with SMTP id
 ada2fe7eead31-605a5139644mr1403489137.32.1775231738311; Fri, 03 Apr 2026
 08:55:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ac-w6e33txkgTRJj@strlen.de> <ac_EY9ciqt5yQ6wr@strlen.de>
In-Reply-To: <ac_EY9ciqt5yQ6wr@strlen.de>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Fri, 3 Apr 2026 08:55:27 -0700
X-Gm-Features: AQROBzDt5ARLDV79X-KOKclhATQ7c5tLSV8mUTRzkTu_Zfk9b8SQmhf-nx8sbrY
Message-ID: <CAFn2buDAPLPjS5fXejDiuY5pV1rduMes2Ho=sSYmFVMVmh5xAw@mail.gmail.com>
Subject: Re: nfnetlink_queue crashes kernel
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 47f7f62906e2..15c6276f6592 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -60,29 +60,10 @@
>   */
>  #define NFQNL_MAX_COPY_RANGE (0xffff - NLA_HDRLEN)

NFQNL_HASH_MIN (1024) and NFQNL_HASH_MAX(1048576) were set when the
table was global, but if table is moved to per queue it can likely be
reduced. Suggested values:

#define NFQNL_HASH_MIN 8
#define NFQNL_HASH_MAX 32768

>
> -cleanup_netlink_subsys:
> -       nfnetlink_subsys_unregister(&nfqnl_subsys);
> -cleanup_netlink_notifier:
> +cleanup_nfqnl_subsys:
> +       netlink_unregister_notifier(&nfqnl_dev_notifier);

Should `netlink_unregister_notifier(&nfqnl_dev_notifier);` be
'unregister_netdevice_notifier(&nfqnl_dev_notifier);' ?

> +cleanup_dev_notifier:
>         netlink_unregister_notifier(&nfqnl_rtnl_notifier);
> +cleanup_rtnl_notifier:
>         unregister_pernet_subsys(&nfnl_queue_net_ops);
> -cleanup_rhashtable:
> -       rhashtable_destroy(&nfqnl_packet_map);
> +cleanup_pernet_subsys:
> +       destroy_workqueue(nfq_cleanup_wq);
>         return status;
>  }
