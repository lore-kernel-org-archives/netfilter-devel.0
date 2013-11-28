From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [RFC nftables kernel PATCH] netfilter: nf_tables: fix
 nft_meta_target module
Date: Thu, 28 Nov 2013 15:33:03 +0100
Message-ID: <CAOkSjBjwCu3qPey44C3i95-GgUk2a5cwj6dzLwH5HjayDYFXwQ@mail.gmail.com>
References: <20131128111557.6154.40370.stgit@nfdev.cica.es>
 <5297382F.60707@linux.intel.com> <CAOkSjBj+XER8sn1eakaTDyDJPUn=t50WFYLE8zF4uP7Ef9TTOA@mail.gmail.com>
 <529745ED.5050201@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:42436 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3K1OdY convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:33:24 -0500
Received: by mail-lb0-f179.google.com with SMTP id l4so6223054lbv.38
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 06:33:23 -0800 (PST)
In-Reply-To: <529745ED.5050201@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28 November 2013 14:32, Tomasz Bursztyka
<tomasz.bursztyka@linux.intel.com> wrote:
>
> Thus, why not adding an attribute to the meta expression. Like:
> NFTA_META_SVAL? (Of course NFTA_META_DREG and this new attribute are
> mutually exclusive)
> I guess then you only need to adapt struct nft_policy in nft_meta_tar=
get.c
> to handle it, and adding value element in its nft_meta struct, and th=
ere you
> are.
>
> Less code and API change.
>

Sounds reasonable. Then we can kill the nft_meta_targe.c file.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
