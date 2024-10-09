Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8BF16BE3A
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 22:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728511378; cv=none; b=kkfdnfzwFxNKSkbYRLFFeOH18Qr5GKWNNb22AnmThGHW9VrnDuBxyASwCNpWK6pYl0bVkANwK0Vv1NeL6g/LjkEIrht7gewI2u6Z97JxHLa/e6NbkbJSzQw3JGe5jWL2hGSSEN6jXaF10TUtGY/kw9Mfs5n/tzrPgnVmen+dOwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728511378; c=relaxed/simple;
	bh=uZxY76m36ydLtto+ybFprLgpvUQq3up5tcHkr6TI6eY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ozgXJFDj6rYT5uWsZ5zs9P5SMWuROpSuyrhHvNCer5eeE/rdvP1E2Ws2TewmxZeOUVLLjKJSXANcjivMjg+w2cDvG81lll0+fD1Tb6JBU6cVtucCXMhljqRhIhL9wQ2qe9/NeXkLXfgYU1ToXTMLj8msHASV0h1umS6wE9N/j6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=G9kM3YPp; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="G9kM3YPp"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e290bf7adaaso266489276.1
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Oct 2024 15:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1728511375; x=1729116175; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qALeGv0lrJMi11SU4W4SJLWzuz/xtDH2PNt93jl4Qu0=;
        b=G9kM3YPp9bL6B52kT7rJeGOWinOt1yjMDHhQRztJguXcw0jHVefIgME54gtjrc5ye6
         OA6b+ty0PnLoAQvOQmk4DzQqKI+jPadjfU8Jhb9YrCAtc9mX9gahlAN9nf0hW/PFlDzH
         tFkXluKxDDm2ssCoiKUfUKMz1kFb6j5S6zBwviRsZQ1Cqi5B6E6s9B0F1YOSeKUZgHol
         QRxiNjP5i2L4CA3NsiOuXSm3T4fDbNlL/tD1Q9GkclUbV2DyfOM+JPO/ikR1NqKUimK6
         ggllE1I/v6dRZk8GFZFU6TOunreyTJEla7i3jTfU7cd9WqSUUN0K6UY8j25Za7Va9veB
         Z6oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728511375; x=1729116175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qALeGv0lrJMi11SU4W4SJLWzuz/xtDH2PNt93jl4Qu0=;
        b=OsfJbhJu251FyUXfVHTqL6p9CJ8vfFdkl+PAPuqGc6y2SOTS90QVzERF6i1fX+VfAf
         vfPqtitRU5lCAlsmSwoDbyJCUUqtgmNdgzFQrDA+gcKFEKDVELKbnTqUidRZ3lrNMldk
         5xSflBSruhe2Y2/cU/47iJ0qlJ+35uQcu9kkdleR0bus3KerhF6C5hwzvUh7xEFDnZXq
         TvM0GrsdPBUClgNGDS6/hyNAyDPg7pmFousbO78RTxd0MUJlmuxqFOn7w1ZcP3wykyzt
         3ErQSK31T9zQpKaAxWMPDH2FY0wRiTy9NT1W9zwqgONnqMplVIAcTghqPoZFeOTDrIpm
         Pocw==
X-Gm-Message-State: AOJu0YyZ2zHbgMsyiY08Nuxp65nDuaZ10zz7GmUz3fWSxhyPKk2tozwq
	GOlHoTvEnOzRIL3z3avwM8GId7mPR2VzahAJB08jQuhyxlxEAQkquU/J/xm69DTwwgTPwWaBQrr
	+h8dGSKutUDg95d6mRi9T6nCDKke0P8Wll80G
X-Google-Smtp-Source: AGHT+IG1hXmGzW6t4TPA1Xvx/ba3I0vLTALPaDTo/4Z8b9Pf7FLaaDUI4r/rqTzCQTCNGBbiARVnORqzWvm00b3PHNQ=
X-Received: by 2002:a05:690c:5083:b0:6e3:3227:ec64 with SMTP id
 00721157ae682-6e33227eff0mr792437b3.35.1728511374654; Wed, 09 Oct 2024
 15:02:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241009203218.26329-1-richard@nod.at>
In-Reply-To: <20241009203218.26329-1-richard@nod.at>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 9 Oct 2024 18:02:44 -0400
Message-ID: <CAHC9VhSbAM3iWxhO+rgJ0d0qOtrSouw0McrjstuP5xQw3=A35Q@mail.gmail.com>
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
To: Richard Weinberger <richard@nod.at>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pabeni@redhat.com, 
	kuba@kernel.org, edumazet@google.com, davem@davemloft.net, 
	kadlec@netfilter.org, pablo@netfilter.org, rgb@redhat.com, 
	upstream+net@sigma-star.at, audit@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 9, 2024 at 4:33=E2=80=AFPM Richard Weinberger <richard@nod.at> =
wrote:
>
> When recording audit events for new outgoing connections,
> it is helpful to log the user info of the associated socket,
> if available.
> Therefore, check if the skb has a socket, and if it does,
> log the owning fsuid/fsgid.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  net/netfilter/xt_AUDIT.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> index b6a015aee0cec..d88b5442beaa6 100644
> --- a/net/netfilter/xt_AUDIT.c
> +++ b/net/netfilter/xt_AUDIT.c
> @@ -9,16 +9,19 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
>  #include <linux/audit.h>
> +#include <linux/cred.h>
> +#include <linux/file.h>
> +#include <linux/if_arp.h>
>  #include <linux/module.h>
>  #include <linux/skbuff.h>
>  #include <linux/tcp.h>
>  #include <linux/udp.h>
> -#include <linux/if_arp.h>
>  #include <linux/netfilter/x_tables.h>
>  #include <linux/netfilter/xt_AUDIT.h>
>  #include <linux/netfilter_bridge/ebtables.h>
> -#include <net/ipv6.h>
>  #include <net/ip.h>
> +#include <net/ipv6.h>
> +#include <net/sock.h>
>
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Thomas Graf <tgraf@redhat.com>");
> @@ -66,7 +69,9 @@ static bool audit_ip6(struct audit_buffer *ab, struct s=
k_buff *skb)
>  static unsigned int
>  audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
>  {
> +       struct sock *sk =3D skb->sk;
>         struct audit_buffer *ab;
> +       bool got_uidgid =3D false;
>         int fam =3D -1;
>
>         if (audit_enabled =3D=3D AUDIT_OFF)
> @@ -99,6 +104,24 @@ audit_tg(struct sk_buff *skb, const struct xt_action_=
param *par)
>         if (fam =3D=3D -1)
>                 audit_log_format(ab, " saddr=3D? daddr=3D? proto=3D-1");
>
> +       if (sk && sk_fullsock(sk)) {
> +               read_lock_bh(&sk->sk_callback_lock);
> +               if (sk->sk_socket && sk->sk_socket->file) {
> +                       const struct file *file =3D sk->sk_socket->file;
> +                       const struct cred *cred =3D file->f_cred;
> +
> +                       audit_log_format(ab, " uid=3D%u gid=3D%u",
> +                                        from_kuid(&init_user_ns, cred->f=
suid),
> +                                        from_kgid(&init_user_ns, cred->f=
sgid));

[CC'ing the audit and LSM lists for obvious reasons]

If we're logging the subjective credentials of the skb's associated
socket, we really should also log the socket's LSM secctx similar to
what we do with audit_log_task() and audit_log_task_context().
Unfortunately, I don't believe we currently have a LSM interface that
return the secctx from a sock/socket, although we do have
security_inode_getsecctx() which *should* yield the same result using
SOCK_INODE(sk->sk_socket).

I should also mention that I'm currently reviewing a patchset which is
going to add proper support for multiple LSMs in audit which will
likely impact this work.

https://lore.kernel.org/linux-security-module/20241009173222.12219-1-casey@=
schaufler-ca.com/

> +                       got_uidgid =3D true;
> +               }
> +               read_unlock_bh(&sk->sk_callback_lock);
> +       }
> +
> +       if (!got_uidgid)
> +               audit_log_format(ab, " uid=3D? gid=3D?");
> +
>         audit_log_end(ab);
>
>  errout:
> --
> 2.35.3

--=20
paul-moore.com
