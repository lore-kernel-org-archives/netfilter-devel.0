Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F0F3D45F7
	for <netfilter-devel@vger.kernel.org>; Fri, 22 May 2026 11:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779447990; cv=pass; b=Fh5sPr5bpkXVDNgipu0J/WYLxog1h/lk0J73lLHzzHUIs0LpuZkaU7Dti7iKUWizPzd+TCW7zAiRbZRMHaXXe1M4ewtfSLnYeSsndfUoqxwYzb89ipn2xk7qQGz0588nyk6wrSZ6EDAV/qVOcmBsIGGKsGMSLgwuR2T1YEaaQas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779447990; c=relaxed/simple;
	bh=Cb8jzTVP/g4hZIUKlfTnMnNDv+bNwVUN4cKy5ljB38g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mVCJU1BmgzkpdTpD1nHWAWjFzJfnEoJHdPpcxMZrT8GZ7L0dXWmpEVpT73hwbl0re7QjWF8YEzaNcBRAV6uGFCikW3hkm5UkHVBMKs05+9WsaZWQTLgNtYZWDbkhDTX43QgmIpuamcyPPBRlQQT61be05DA0guwIx8q/5Pvz6y0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g+qgeWZd; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g+qgeWZd"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-516d0db9372so10285661cf.2
        for <netfilter-devel@vger.kernel.org>; Fri, 22 May 2026 04:06:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779447987; cv=none;
        d=google.com; s=arc-20240605;
        b=U03Rgkl+C/89eNiwNapl3MXKZbY8Doq8RFVSi/Pe7RkG0IJ7GzAiuhjUQC491XAdOd
         tf0L5ux7Q3vRCAHzN+IKV5TuuPqBCC5FehxglIbM56j4trxekUIsgXhk7npacR3WJU4v
         T4ljPBnGtqzFLkPfPfj2jrTD6tHXGKJXwPjOSPZ/eMqA1sYdoMSeEqQjFcvZB/jqR1g/
         DN10waMSLXEBRBUL8VDTa7Zbr8sSyOhf9XBrB539nkXcdewrqVehcizcBG8GOYEnrfgd
         TUOE14Upb91nSscU/2K+xvrKUmAk30Mkg7rmgX60yKkDOSmuU0JpxycZ5qdqrmJxb4oL
         jkZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4ej6QpaknZjbuF3/decAt6oWWqXsmIj8KOp/5Rx73bU=;
        fh=RsKlzacGP0NEFGfOqkbyZSBRVdRLahmaIodrbnIuEGg=;
        b=QTHDGLp7kZFhAsMVjoShedayrdBB9FLzUirkY6Uo/8uN9okOkB8IHpriWbnzrJPbpG
         QEaeqRDrorMNLLQNmmBwP3sUatYux366Y3iv55zT8Gh+3Q6wcjKu33Q5L6DhMiooHiI+
         cT9Oewzgj1WTEOwwPqp3+slNKAFUtQGts5/bPOU3MSBHx1+P2CX1gM+DP/K3behqgAXy
         O3Um0ZitUK9AljwneKs1TC6J9hdwBZbwQElVTB9NMc+cCcD3cObZxar35ZeuLSdK7m9N
         f9IpJEhD/1bBOyAb1LL6ViYymCzQLpgC5gmX8tVPmHvNsg62AKsIUJ8xIseNgGCYcYZZ
         DdRw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779447987; x=1780052787; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ej6QpaknZjbuF3/decAt6oWWqXsmIj8KOp/5Rx73bU=;
        b=g+qgeWZdwGThOpc3lcrH7zpUN6OJjfeiIQ6Sjp9jZ1LXmwXKn9CeH3BqUrW3rXfRmM
         9pFQFPcdA2AsybKCOYpKRveDJQLxeRadWY+oTenXAmwdAVxTccdVXb4dl67CNIYr/4qe
         Vcd6o3mIGv55CtqC6AKcdrFdJUvfGmehvskTtTfsolWvdkb6QXnUjYxphn9Ly0rQYFmU
         K+sQWz+ykHgcXU+MH8laUMnkEcJUmIUYPTCCe85QGg6dHiJTfS+M00ODZBS760tRrhpH
         yLtwJQxQ0pY48RGhRpFHstWiZlSvT6lesc++MHVtUKzbuq5LQkn/Hl89dNAungw/C8tp
         2wdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779447987; x=1780052787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4ej6QpaknZjbuF3/decAt6oWWqXsmIj8KOp/5Rx73bU=;
        b=O0xhaATkJlAObKvgTJ0w+pD3wDmGhsm1JZgedXziXPqaQ8KQCIf0lmtpZ4XaEE30y6
         ZzlKvOlEiFiOTLkxhnODyEobrdC65P5yAtkq7keOekcDMc0DJvqCZJn0e0wrWrWPVUbB
         ygEMswgCAlcM/3/QGJPYTmbfpA7oSsv0RH1XAVvbrWQ5SzJozBb8KFsvEu+tlxibvDZg
         bSNTjQeNdMbXif2WI59V/U66w427x7IxDroVR7GCdo26Z31H1hPLTmyEP7N+B/QCNjVj
         bAGN5oVSB/6cJBGx+jZhtK4XvUtxTiK9Dm4HeX5lPYSxxns+YizDfDO+QjWgBZo9VMbt
         ISPw==
X-Forwarded-Encrypted: i=1; AFNElJ9QaQlubQFs+2nGpmoLXQBSlmraqH6JmCGnMjKExkDaeUgE09zlNMeee5MKE9xg/dpAHR1xKdiKSjSdGbZN3pY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEitDM0ylfimhZ2swGGq5SJferTUeBEe9x83OLcAnpdpNNwFFs
	+OuM6TcJlzVDlbdp0F6dIzfJov5wQHtFFP1PZ3clrmooz2ngdEDodlcROois0savIUBJlXMVNgN
	LLQcRJfb5Tg5GfiumPccvqTqlOGkecugApaxOdBCQ
X-Gm-Gg: Acq92OF5chhkdOuX4b11cfNJe6f7BLC2RxF0LVqdswwjc2mPz3q1EIEMU2jzvz0nmW+
	31HvsgK8VNDkVIBy3qR+Z/41atqfJrXaJ5svz9R/TzgQAgMnKnPjhMxXIKprN/GJZuuJI5w80+v
	JCXoDTwVb+YNRV8MfoyVT9hQpjbXLOAx0Ef1obPdciidksAIKw/NwN3cUDQtBNIkPWQBXPnp42C
	ATZE7q/V76xjDEA3xRvkd+rVJk9hUvqDjs7pxQcJv8FOtNffu3kTF8p0terV57Z3UzzKD9vu6CN
	Lvlj2CnNJw0PrQSNIbzyH2EfLMQLNLravg0RoxjxFS0uF4VFSUSViB2PS2B87GdkLFfN37hY8/h
	l+nfI+on4rnKlaEgVMCrHqtvZhWoHmO51YPlbOONa+2IHSZ2PuhsO0TAlB88SkG66
X-Received: by 2002:a05:622a:a942:b0:516:d5aa:42d5 with SMTP id
 d75a77b69052e-516d5aa4534mr34969431cf.10.1779447986114; Fri, 22 May 2026
 04:06:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260522104257.2008-1-fw@strlen.de> <20260522104257.2008-5-fw@strlen.de>
In-Reply-To: <20260522104257.2008-5-fw@strlen.de>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 22 May 2026 04:06:14 -0700
X-Gm-Features: AVHnY4JAvpfq33Omq5xczX5BUpmPFogQtSNG7NfdvnnXCyQleptcPiwbspf5ErM
Message-ID: <CANn89i+_Mt220itgSf0P476U_=ayRpKomiQgqy1QYnF3g9UrdA@mail.gmail.com>
Subject: Re: [PATCH net 04/10] netfilter: xt_cpu: prefer raw_smp_processor_id
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org, 
	pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 22, 2026 at 3:43=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> With PREEMPT_RCU we get splat:
>
> BUG: using smp_processor_id() in preemptible [..]
> caller is cpu_mt+0x53/0xd0 net/netfilter/xt_cpu.c:37
> CPU: 1 .. Comm: syz.3.1377 #0 PREEMPT(full)
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
>  cpu_mt+0x53/0xd0 net/netfilter/xt_cpu.c:37
>  [..]
>
> Just use raw version instead.
> This is similar to 14d14a5d2957 ("netfilter: nft_meta: use raw_smp_proces=
sor_id()").
>
> Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x=
_tables")
> Reported-by: syzbot+690d3e3ffa7335ac10eb@syzkaller.appspotmail.com
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks!
