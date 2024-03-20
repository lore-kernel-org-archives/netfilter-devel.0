Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB8F42044
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 14:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710944097; cv=none; b=Tk1mO/r7Reh5J057IwTge3R4eMGQo6Q55/ANmSp0DGVyo/WjmmdEDT9eZSInkhdU9q+Lnb3n9KnGKAMU4EeWGM+3TZNsrNKXnCoiEG20iGI1arAuYDPCMzsAQsLOVWgbO4q3UBkiwTgbPK8TteDdri9xj/FbOvOxDp3X68K0DPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710944097; c=relaxed/simple;
	bh=XRapKtc108/pbXuzQ1RvASghSkGRFTXgTzWiVgsKsbU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RhiepNvOGLT9YSSi9w919l5V1LxvjI+6VwL0TxcjEc0jYSDnA8NRJ/Nkh4b9c4vAt0IHOUL2Y/fUuHLPshtaE7yGgedvLZLljIc5sPoDxqZdX74YunVVYHJ9v7RUIpm0KqFcERxPlaGYwwF/dJ9z2rqsm3gUlb4vALBDQ1ZOx74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z8Id/Iy6; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z8Id/Iy6"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-568c3888ad7so14924a12.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 07:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710944094; x=1711548894; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZE0o19ZPW4Q/J+OTjU7JW8PmpitVelX4zaEFtGnHi3c=;
        b=Z8Id/Iy60LZs44BCxYP3Zt5qv8IhLV2OntSsV3wY0NG3wQ2DK6YBeO3RcCu1rZ5Rmd
         MdXhBKtxcyxPHY8mX91+p3JmvD3z+GCI/KlDwTyDq22IUFAmQDeeK7QhnMyRORNavKDo
         PT9pm4ZShS7i5swjNwc/yq/21K31w0uDjk2zWic/4XElikejHUYer1GApPKrDOCGqAJg
         RWB+XVJxC803r6SColRcecYIMCvJ2uRBiAPXuEYOOk1q/K7Wy268mC2oOT/W/wHInw/T
         2AkWPN27wc3dBzV5EpY3vbKoBXdeb/UK71NhzUYX8QKiS9Ac0llZWJfpFRsIu1UYf8fg
         9OIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710944094; x=1711548894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZE0o19ZPW4Q/J+OTjU7JW8PmpitVelX4zaEFtGnHi3c=;
        b=t3PxKAXEsk4IIqqaOIjbz5CACcPtvx6dexxJRV9ruGaHGbZX2r3Ewy+Ceffk62IlGK
         uFuhh4E7opGK7O999u4UrOmRyICdcS+UokFKUB/Hv3sph2pjN4XmqWOKUtj2Vi91P/w4
         RR/5RAKZSLJqXu40ALM4w29Ti/sYZargrd6VMJd8CrUCibmJOU5wdnd6i48d3KpXTdYy
         elBYQSfGDZJ8pTDAtawq0lPGohhd4CTFBy+GZe2na87ATienmWtMK8AkWzRvBESGO1we
         7Nq51bDBCtcmFiLpuPyBhJE6pq7tNLSQo+kZJlMoaTtPoZOfsp82L/FGU/8wuXcOoBlu
         JUrw==
X-Forwarded-Encrypted: i=1; AJvYcCUQiS0YR7W4OsW6NTWg3eRaaBt2+qoMg7RhEoQWjI9jt5ZPM8YdujOEJqJ3fwXL9DoUS8zGs5WYvt9QOiyAY2uTSHmrz515oSv4Isgsx0p9
X-Gm-Message-State: AOJu0YywtDtWLD4yrHwCPNF7i/yNk9+5wuTHqUAG6CyJQSP6ok+yROOU
	QDWEJ7WIhFMNuNNLcTxntGDbekQdMa+rM/AbhKUEffiv17Xug5dtMhtn2Z90KJqGuwtOiMGp1c3
	lueyymx/nSt/UiLA0gfz6BYW/M0Ah2ebnytLk
X-Google-Smtp-Source: AGHT+IGf0RnNraDVYsG4wNxD4IMSs+QTaVw1IHmThYiPMNDH/bOviRgGHyFdKUlbI8k0p/2JQiZKnkIA61ighrrHDQw=
X-Received: by 2002:aa7:d4cf:0:b0:56b:b856:7eb6 with SMTP id
 t15-20020aa7d4cf000000b0056bb8567eb6mr58115edr.6.1710944093653; Wed, 20 Mar
 2024 07:14:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319122310.27474-1-fw@strlen.de>
In-Reply-To: <20240319122310.27474-1-fw@strlen.de>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 20 Mar 2024 15:14:40 +0100
Message-ID: <CANn89i+S0EYPM4N-3RsN5-QDQts5wobJjBikF7=feMo6hHY3Lw@mail.gmail.com>
Subject: Re: [PATCH net] inet: inet_defrag: prevent sk release while still in use
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, kuba@kernel.org, 
	pabeni@redhat.com, netfilter-devel@vger.kernel.org, 
	xingwei lee <xrivendell7@gmail.com>, yue sun <samsun1006219@gmail.com>, 
	syzbot+e5167d7144a62715044c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 12:36=E2=80=AFPM Florian Westphal <fw@strlen.de> wr=
ote:
>
> ip_local_out() and other functions can pass skb->sk as function argument.
>
> If the skb is a fragment and reassembly happens before such function call
> returns, the sk must not be released.
>
> This affects skb fragments reassembled via netfilter or similar
> modules, e.g. openvswitch or ct_act.c, when run as part of tx pipeline.
>
> Eric Dumazet made an initial analysis of this bug.  Quoting Eric:
>   Calling ip_defrag() in output path is also implying skb_orphan(),
>   which is buggy because output path relies on sk not disappearing.
>
>   A relevant old patch about the issue was :
>   8282f27449bf ("inet: frag: Always orphan skbs inside ip_defrag()")
>
>   [..]
>
>   net/ipv4/ip_output.c depends on skb->sk being set, and probably to an
>   inet socket, not an arbitrary one.
>
>   If we orphan the packet in ipvlan, then downstream things like FQ
>   packet scheduler will not work properly.
>
>   We need to change ip_defrag() to only use skb_orphan() when really
>   needed, ie whenever frag_list is going to be used.
>
> Eric suggested to stash sk in fragment queue and made an initial patch.
> However there is a problem with this:
>
> If skb is refragmented again right after, ip_do_fragment() will copy
> head->sk to the new fragments, and sets up destructor to sock_wfree.
> IOW, we have no choice but to fix up sk_wmem accouting to reflect the
> fully reassembled skb, else wmem will underflow.
>
> This change moves the orphan down into the core, to last possible moment.
> As ip_defrag_offset is aliased with sk_buff->sk member, we must move the
> offset into the FRAG_CB, else skb->sk gets clobbered.
>
> This allows to delay the orphaning long enough to learn if the skb has
> to be queued or if the skb is completing the reasm queue.
>
> In the former case, things work as before, skb is orphaned.  This is
> safe because skb gets queued/stolen and won't continue past reasm engine.
>
> In the latter case, we will steal the skb->sk reference, reattach it to
> the head skb, and fix up wmem accouting when inet_frag inflates truesize.
>
> Diagnosed-by: Eric Dumazet <edumazet@google.com>
> Reported-by: xingwei lee <xrivendell7@gmail.com>
> Reported-by: yue sun <samsun1006219@gmail.com>
> Reported-by: syzbot+e5167d7144a62715044c@syzkaller.appspotmail.com
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/skbuff.h                  |  7 +--
>  net/ipv4/inet_fragment.c                | 71 ++++++++++++++++++++-----
>  net/ipv4/ip_fragment.c                  |  2 +-
>  net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
>  4 files changed, 61 insertions(+), 21 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 7d56ce195120..6d08ff8a9357 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -753,8 +753,6 @@ typedef unsigned char *sk_buff_data_t;
>   *     @list: queue head
>   *     @ll_node: anchor in an llist (eg socket defer_list)
>   *     @sk: Socket we are owned by
> - *     @ip_defrag_offset: (aka @sk) alternate use of @sk, used in
> - *             fragmentation management
>   *     @dev: Device we arrived on/are leaving by
>   *     @dev_scratch: (aka @dev) alternate use of @dev when @dev would be=
 %NULL
>   *     @cb: Control buffer. Free for use by every layer. Put private var=
s here
> @@ -875,10 +873,7 @@ struct sk_buff {
>                 struct llist_node       ll_node;
>         };
>
> -       union {
> -               struct sock             *sk;
> -               int                     ip_defrag_offset;
> -       };
> +       struct sock             *sk;
>
>         union {
>                 ktime_t         tstamp;
> diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
> index 7072fc0783ef..7254b640ba06 100644
> --- a/net/ipv4/inet_fragment.c
> +++ b/net/ipv4/inet_fragment.c
> @@ -24,6 +24,8 @@
>  #include <net/ip.h>
>  #include <net/ipv6.h>
>
> +#include "../core/sock_destructor.h"
> +
>  /* Use skb->cb to track consecutive/adjacent fragments coming at
>   * the end of the queue. Nodes in the rb-tree queue will
>   * contain "runs" of one or more adjacent fragments.
> @@ -39,6 +41,7 @@ struct ipfrag_skb_cb {
>         };
>         struct sk_buff          *next_frag;
>         int                     frag_run_len;
> +       int                     ip_defrag_offset;
>  };
>
>  #define FRAG_CB(skb)           ((struct ipfrag_skb_cb *)((skb)->cb))
> @@ -396,12 +399,12 @@ int inet_frag_queue_insert(struct inet_frag_queue *=
q, struct sk_buff *skb,
>          */
>         if (!last)
>                 fragrun_create(q, skb);  /* First fragment. */
> -       else if (last->ip_defrag_offset + last->len < end) {
> +       else if (FRAG_CB(last)->ip_defrag_offset + last->len < end) {
>                 /* This is the common case: skb goes to the end. */
>                 /* Detect and discard overlaps. */
> -               if (offset < last->ip_defrag_offset + last->len)
> +               if (offset < FRAG_CB(last)->ip_defrag_offset + last->len)
>                         return IPFRAG_OVERLAP;
> -               if (offset =3D=3D last->ip_defrag_offset + last->len)
> +               if (offset =3D=3D FRAG_CB(last)->ip_defrag_offset + last-=
>len)
>                         fragrun_append_to_last(q, skb);
>                 else
>                         fragrun_create(q, skb);
> @@ -418,13 +421,13 @@ int inet_frag_queue_insert(struct inet_frag_queue *=
q, struct sk_buff *skb,
>
>                         parent =3D *rbn;
>                         curr =3D rb_to_skb(parent);
> -                       curr_run_end =3D curr->ip_defrag_offset +
> +                       curr_run_end =3D FRAG_CB(curr)->ip_defrag_offset =
+
>                                         FRAG_CB(curr)->frag_run_len;
> -                       if (end <=3D curr->ip_defrag_offset)
> +                       if (end <=3D FRAG_CB(curr)->ip_defrag_offset)
>                                 rbn =3D &parent->rb_left;
>                         else if (offset >=3D curr_run_end)
>                                 rbn =3D &parent->rb_right;
> -                       else if (offset >=3D curr->ip_defrag_offset &&
> +                       else if (offset >=3D FRAG_CB(curr)->ip_defrag_off=
set &&
>                                  end <=3D curr_run_end)
>                                 return IPFRAG_DUP;
>                         else
> @@ -438,23 +441,39 @@ int inet_frag_queue_insert(struct inet_frag_queue *=
q, struct sk_buff *skb,
>                 rb_insert_color(&skb->rbnode, &q->rb_fragments);
>         }
>
> -       skb->ip_defrag_offset =3D offset;
> +       FRAG_CB(skb)->ip_defrag_offset =3D offset;
>
>         return IPFRAG_OK;
>  }
>  EXPORT_SYMBOL(inet_frag_queue_insert);
>
> +void tcp_wfree(struct sk_buff *skb);

Thanks a lot Florian for looking at this !

Since you had : #include "../core/sock_destructor.h", perhaps the line
can be removed,
because it includes <net/tcp.h>
