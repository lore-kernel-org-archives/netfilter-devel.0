Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6B5152E0B
	for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2024 12:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714740403; cv=none; b=LoSbV1T0XnTWdSmREyYZMFYIMGXDUdn3spXn5wYZw6jCgTkxacTkiCAC1RLu4Ct/M4BLXwMpnF99vwUQwy1QIes3YxS+nEmtvtyETMqSoMgpICqfgy2zp1zuiJKeB0Wq8DA5lOtCOOWeVAtJf2DHYi8AH9ms0przAnU0zV2oZhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714740403; c=relaxed/simple;
	bh=mMRs+UvwiF35nZLgTeLJLeyztQeDuxUwpDf+Df3+800=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aCofLWqhn6DsEDr4pZfudh8dDLMvRK7OOgCPvv0AgbHgdS5OjOv6J4u19KxC8MxT163VxOBqLBmbjF77hLZ7WROR1SQviXSQS2u7Lzw8Svf+HXWJASmrhsXFNF8dDMusB0cIoNkv+UM8gqiMluStPX5Xs+z8l982P0uhSIKkkbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jsof15uw; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jsof15uw"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-418820e6effso53905e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 03 May 2024 05:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714740400; x=1715345200; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uV0Z27uIoH5S6uUW+Nf4hCgWHobWVUIh46vuWcKgxzs=;
        b=Jsof15uwXSAH18uTJsh4OW0PaohozlP17lV+fH5Jx6sqbNbEaLQYHJk87sfXzm4uMZ
         QdqRD8HuKBDJ7aDqxV8RoAoUE82r5bDwT2UyLXOjIlK0FqswcF3l0lapWLDvMBQjw86c
         qeOHBouZSp17JMPiPx/RecjvfjmVOZryx5spXHFt7IFprhrSiDPmYrWJMqJl7hrQi+GV
         0l/F5lRQAMAgWihldlyDO4X6+jVVRALtY3OosqmVv637Dwuj5yyS2tKGtFpbl8Q4L9gB
         jDAylpgWCVItoHfNv3mmYMhaw3GcwFnR63o5H7RiSzWzfZ7S31MxICIQkVUgvq76OSfV
         4+/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714740400; x=1715345200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uV0Z27uIoH5S6uUW+Nf4hCgWHobWVUIh46vuWcKgxzs=;
        b=ESHW1a6kf5pmZdo76xTmddzCaJcc5EJ+wzjQqau5AXQNZIrAbKKteKvUr9RIuSlpOu
         nKgO8DQXTkrk2Kw1e4usCjh93Ny5c6x77VidnmrWKRGfsuIdm5vBiOWcDu1wzVrkmEpF
         ycQE+aNhmFDTK8khofk+xfzYqFrgXZNQff0pd20RSPNMgTNfURYfs3JFMQSv3i9tdsmq
         FlgRG4ZI3v8/pEzC7UrAtpWqV3J+rt26DNvvCk6TdOgNp9zWX1CGSry+oXMzCH2isoen
         t1aN+nySB11S2oU4RRzp8P2OI6TIRRwUsr+2Jv8TmfAmIydpy3+k6dk2e4WYtaOgJGS7
         FIlA==
X-Gm-Message-State: AOJu0Yw4J9lZgDW70kP0zLsjUGxz/M4cAPiNy1CxCf37rllLjffPGEEw
	BcPuKLy2QMTw1nz3EDFvLpukBV9eHM90bC/LIG2T6WVTyk3NueQNqFSZNW4Hjn7WAT4nuK4vWz2
	VEILLv8hbKh9FtOr1JwHz1UICNNABUGEj2paWu6IMkNEWlsIjckwD
X-Google-Smtp-Source: AGHT+IEnGyfWZw0ffzFq0zhsMHraPL9Iou6BKbMqPendMy9FtCPyUt5lOg1BglRvDEBWpBGNjb08FAyv0b8WJ/1jhMs=
X-Received: by 2002:a05:600c:1caa:b0:419:b16:9c14 with SMTP id
 5b1f17b1804b1-41e1c048a59mr1325695e9.1.1714740399583; Fri, 03 May 2024
 05:46:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240503113456.864063-1-aojea@google.com> <20240503113456.864063-2-aojea@google.com>
In-Reply-To: <20240503113456.864063-2-aojea@google.com>
From: Antonio Ojea <aojea@google.com>
Date: Fri, 3 May 2024 14:46:27 +0200
Message-ID: <CAAdXToSN6h9vf8wSA3aQz6wU7pkuWsE5=tQ5qNRX_oQhTxNu=Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] netfilter: nft_queue: compute SCTP checksum
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de, pablo@netfilter.org, willemb@google.com, edumazet@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 3, 2024 at 1:35=E2=80=AFPM Antonio Ojea <aojea@google.com> wrot=
e:
>
> when the packet is processed with GSO and is SCTP it has to take into
> account the SCTP checksum.
>
> Signed-off-by: Antonio Ojea <aojea@google.com>
> ---
>  net/netfilter/nfnetlink_queue.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_qu=
eue.c
> index 00f4bd21c59b..428014aea396 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -600,6 +600,7 @@ nfqnl_build_packet_message(struct net *net, struct nf=
qnl_instance *queue,
>         case NFQNL_COPY_PACKET:
>                 if (!(queue->flags & NFQA_CFG_F_GSO) &&
>                     entskb->ip_summed =3D=3D CHECKSUM_PARTIAL &&
> +                   (skb_csum_is_sctp(entskb) && skb_crc32c_csum_help(ent=
skb)) &&

My bad, this is wrong, it should be an OR so skb_checksum_help is
always evaluated.
Pablo suggested in the bugzilla to use a helper, so I'm not sure this
is the right fix, I've tried
to look for similar solutions to find a more consistent solution but
I'm completely new to the
kernel codebase so some guidance will be appreciated.

-                   skb_checksum_help(entskb))
+                   ((skb_csum_is_sctp(entskb) &&
skb_crc32c_csum_help(entskb)) ||
+                   skb_checksum_help(entskb)))

                data_len =3D READ_ONCE(queue->copy_range);

>                     skb_checksum_help(entskb))
>                         return NULL;
>
> --
> 2.45.0.rc1.225.g2a3ae87e7f-goog
>
