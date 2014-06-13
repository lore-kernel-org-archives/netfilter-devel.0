From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: add pktype support to meta expression
Date: Fri, 13 Jun 2014 08:13:32 +0200
Message-ID: <CAOkSjBgJ4DZSe3=EChE-vNQyShdJEqHHr6t5PaJvHdmf1LJC_g@mail.gmail.com>
References: <1402593473-4904-1-git-send-email-anarey@gmail.com> <1402593473-4904-2-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Alvaro Neira Ayuso <alvaroneay@gmail.com>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:43489 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaFMGNy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:13:54 -0400
Received: by mail-la0-f46.google.com with SMTP id gl10so1193708lab.5
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2014 23:13:53 -0700 (PDT)
In-Reply-To: <1402593473-4904-2-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 June 2014 19:17, Ana Rey <anarey@gmail.com> wrote:
[...]
> @@ -194,6 +210,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
>  #endif
>  #ifdef CONFIG_NETWORK_SECMARK
>         case NFT_META_SECMARK:
> +       case NFT_META_PKTTYPE:
>  #endif

Why to enclose this in the #ifdef CONFIG_NETWORK_SECMARK?

regards
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
