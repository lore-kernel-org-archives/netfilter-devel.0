Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E6CEB64D7
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 15:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjFUPs2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 11:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjFUPs1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 11:48:27 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121E2BC
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 08:48:26 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e9e14a558f8ab-34226590ee3so253255ab.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 08:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687362505; x=1689954505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/xansB3QT4lIxk9Lg5wB/a+92qhZa8W4kR5MFYwkgsI=;
        b=euZK0/IdXJPaIZPDeaxeOQLjILZ8FG4TxSSx7pYUP7BgPZw1vK8A+yfJi+PpL8EwQU
         VCHVseOL8oIiLc7QKfglYSg9RzhsSBDPBXRRQ5oyrKkp73eajb7gbZQ0BMw5mavmWLoB
         6crRP7La1VwAlWclCZlsIgYZD1y5QHXQaQqCvIvmtNhcAc2C5PpSX1aJnMMBzVXVB3vb
         IxZGoUQ9F3qg7/tHQrMl4/DT/64XcoIWJFYPu40dukdqpp8DQOA9GVFjD4TZe6dZkb7q
         m+RmbeTin+97Cu4Hu2yN4jE7A5zircyX702J+BKrHk5zSU5UMpZW2bOtz1KxJWM5cFZf
         U61A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687362505; x=1689954505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/xansB3QT4lIxk9Lg5wB/a+92qhZa8W4kR5MFYwkgsI=;
        b=ZEIwN6idknjSp9ylShL8ITAXVNmFU+B7mJu+5QhJAMZosBxj3PyCQDqgwfkNYwLBxS
         aAxcXiA2Ze5xgXHxLQ2D5X41+wJx1FoVD258UdMbppSnrYMiRjGcTzyGltTk+fRj/WGj
         5QWp3HzltypEGs0QRY1iX0nd//rRx827ddQqqMIp+UcgtSAThE/liYFzcxZ/XR3fVTae
         YEG3go7rEojp7fG6bXsC84Cjb7eyyV9Oyr6gmwEubU5B66Q4Um5Yg0M/bMQs7d2RrVMG
         UIw662qp87NnCcY+QEqey3VJuzBmDyCtI+3Cu7xr5rzUpOh/3t5cjRr5aTvvJtNdpBGz
         ucjQ==
X-Gm-Message-State: AC+VfDxZJ1tBJVZSDlKZO4BQkT7dUQorIS26bdEdkuq/0dgdJNcVeHh7
        Blp6f5PH41IY1BI6bkPREIhxfsCxyAlhLiRfOSi4O0uYtW5T0IQaSVAtsA==
X-Google-Smtp-Source: ACHHUZ6v9iHnZdbJJC6WzQvfHa8gMkewpjWlxqxgZ7v8XQUo+uLWHbKK4v02+RL5gxN2Uyzq5FLknMS/vqA6LJ3G9mE=
X-Received: by 2002:a05:6e02:188e:b0:33d:ac65:f95e with SMTP id
 o14-20020a056e02188e00b0033dac65f95emr1491846ilu.12.1687362505191; Wed, 21
 Jun 2023 08:48:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230621154451.8176-1-fw@strlen.de>
In-Reply-To: <20230621154451.8176-1-fw@strlen.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 21 Jun 2023 17:48:13 +0200
Message-ID: <CANn89i+RGTkWuOeVwf5ocRuk4+heQcEeZVFcrRKeR4sRKoN1KQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: conntrack: dccp: copy entire header to
 stack buffer, not just basic one
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 21, 2023 at 5:44=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Eric Dumazet says:
>   nf_conntrack_dccp_packet() has an unique:
>
>   dh =3D skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
>
>   And nothing more is 'pulled' from the packet, depending on the content.
>   dh->dccph_doff, and/or dh->dccph_x ...)
>   So dccp_ack_seq() is happily reading stuff past the _dh buffer.
>
> BUG: KASAN: stack-out-of-bounds in nf_conntrack_dccp_packet+0x1134/0x11c0
> Read of size 4 at addr ffff000128f66e0c by task syz-executor.2/29371
> [..]
>
> Fix this by increasing the stack buffer to also include room for
> the extra sequence numbers and all the known dccp packet type headers,
> then pull again after the initial validation of the basic header.
>
> While at it, mark packets invalid that lack 48bit sequence bit but
> where RFC says the type MUST use them.
>
> Compile tested only.
>
> Heads-up: I intend to remove dccp conntrack support later this year.
>
> Fixes: 2bc780499aa3 ("[NETFILTER]: nf_conntrack: add DCCP protocol suppor=
t")
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_proto_dccp.c | 50 ++++++++++++++++++++++++-
>  1 file changed, 48 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_c=
onntrack_proto_dccp.c
> index c1557d47ccd1..745a1f76c249 100644
> --- a/net/netfilter/nf_conntrack_proto_dccp.c
> +++ b/net/netfilter/nf_conntrack_proto_dccp.c
> @@ -432,9 +432,19 @@ static bool dccp_error(const struct dccp_hdr *dh,
>                        struct sk_buff *skb, unsigned int dataoff,
>                        const struct nf_hook_state *state)
>  {
> +       static const unsigned long require_seq48 =3D 1 << DCCP_PKT_REQUES=
T |
> +                                                  1 << DCCP_PKT_RESPONSE=
 |
> +                                                  1 << DCCP_PKT_CLOSEREQ=
 |
> +                                                  1 << DCCP_PKT_CLOSE |
> +                                                  1 << DCCP_PKT_RESET |
> +                                                  1 << DCCP_PKT_SYNC |
> +                                                  1 << DCCP_PKT_SYNCACK;
>         unsigned int dccp_len =3D skb->len - dataoff;
>         unsigned int cscov;
>         const char *msg;
> +       u8 type;
> +
> +       BUILD_BUG_ON(DCCP_PKT_INVALID >=3D BITS_PER_LONG);
>
>         if (dh->dccph_doff * 4 < sizeof(struct dccp_hdr) ||
>             dh->dccph_doff * 4 > dccp_len) {
> @@ -459,26 +469,57 @@ static bool dccp_error(const struct dccp_hdr *dh,
>                 goto out_invalid;
>         }
>
> -       if (dh->dccph_type >=3D DCCP_PKT_INVALID) {
> +       type =3D dh->dccph_type;
> +       if (type >=3D DCCP_PKT_INVALID) {
>                 msg =3D "nf_ct_dccp: reserved packet type ";
>                 goto out_invalid;
>         }
> +
> +       if (test_bit(type, &require_seq48) && !dh->dccph_x) {
> +               msg =3D "nf_ct_dccp: type lacks 48bit sequence numbers";
> +               goto out_invalid;
> +       }
> +
>         return false;
>  out_invalid:
>         nf_l4proto_log_invalid(skb, state, IPPROTO_DCCP, "%s", msg);
>         return true;
>  }
>
> +struct nf_conntrack_dccp_buf {
> +       struct dccp_hdr _dh;     /* must be first */
> +       struct dccp_hdr_ext ext; /* optional depending dh->dccph_x */
> +       union {                  /* depends on header type */
> +               struct dccp_hdr_ack_bits ack;
> +               struct dccp_hdr_request req;
> +               struct dccp_hdr_response response;
> +               struct dccp_hdr_reset rst;
> +       } u;
> +};
> +
> +static struct dccp_hdr *
> +dccp_header_pointer(const struct sk_buff *skb, int offset, const struct =
dccp_hdr *dh,
> +                   struct nf_conntrack_dccp_buf *buf)
> +{
> +       unsigned int hdrlen =3D __dccp_hdr_len(dh);
> +
> +       if (hdrlen > sizeof(*buf))
> +               return NULL;
> +
> +       return skb_header_pointer(skb, offset, hdrlen, buf);
> +}
> +
>  int nf_conntrack_dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
>                              unsigned int dataoff,
>                              enum ip_conntrack_info ctinfo,
>                              const struct nf_hook_state *state)
>  {
>         enum ip_conntrack_dir dir =3D CTINFO2DIR(ctinfo);
> -       struct dccp_hdr _dh, *dh;
> +       struct nf_conntrack_dccp_buf _dh;
>         u_int8_t type, old_state, new_state;
>         enum ct_dccp_roles role;
>         unsigned int *timeouts;
> +       struct dccp_hdr *dh;
>
>         dh =3D skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);

sizeof(struct dccp_hdr) , or sizeof(_dh._dh) ?

>         if (!dh)
> @@ -487,6 +528,11 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct, str=
uct sk_buff *skb,
>         if (dccp_error(dh, skb, dataoff, state))
>                 return -NF_ACCEPT;
>
> +       /* pull again, including possible 48 bit sequences and subtype he=
ader */
> +       dh =3D dccp_header_pointer(skb, dataoff, dh, &_dh);
> +       if (!dh)
> +               return NF_DROP;
> +
>         type =3D dh->dccph_type;
>         if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh, state))
>                 return -NF_ACCEPT;
> --
> 2.39.3
>
