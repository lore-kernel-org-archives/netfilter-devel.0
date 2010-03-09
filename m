From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/1] netfilter: nf_ct_tcp: pack nf_ct_tcp_flags to
 match user space
Date: Tue, 09 Mar 2010 18:02:30 +0100
Message-ID: <1268154150.3113.17.camel@edumazet-laptop>
References: <1268153297-4226-1-git-send-email-ljaenicke@innominate.com>
	 <1268153297-4226-2-git-send-email-ljaenicke@innominate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Lutz Jaenicke <ljaenicke@innominate.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47707 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab0CIRCl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:02:41 -0500
Received: by bwz1 with SMTP id 1so4092821bwz.21
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Mar 2010 09:02:39 -0800 (PST)
In-Reply-To: <1268153297-4226-2-git-send-email-ljaenicke@innominate.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 09 mars 2010 =C3=A0 17:48 +0100, Lutz Jaenicke a =C3=A9crit :
> On some platforms (here: Intel IXP4xx ARM big endian)
> sizeof(struct nf_ct_tcp_flags) evaluates to 4 bytes while in the user
> space code 2 bytes is hard coded.
> Add "__attribute__ ((__packed__))" to enforce matching structure
> sizes.
>=20
> Signed-off-by: Lutz Jaenicke <ljaenicke@innominate.com>
> ---
>  include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/lin=
ux/netfilter/nf_conntrack_tcp.h
> index 6e135f9..c7ee4ec 100644
> --- a/include/linux/netfilter/nf_conntrack_tcp.h
> +++ b/include/linux/netfilter/nf_conntrack_tcp.h
> @@ -39,7 +39,7 @@ enum tcp_conntrack {
>  /* The field td_maxack has been set */
>  #define IP_CT_TCP_FLAG_MAXACK_SET		0x20
> =20
> -struct nf_ct_tcp_flags {
> +struct __attribute__ ((packed)) nf_ct_tcp_flags {
>  	__u8 flags;
>  	__u8 mask;
>  };

Preferred way is to use :

struct nf_ct_tcp_flags {
	...
	} __attribute__ ((packed));


This eases grep games a bit.

Thanks


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
