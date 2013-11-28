From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [RFC nftables kernel PATCH] netfilter: nf_tables: fix
 nft_meta_target module
Date: Thu, 28 Nov 2013 14:15:29 +0100
Message-ID: <CAOkSjBj+XER8sn1eakaTDyDJPUn=t50WFYLE8zF4uP7Ef9TTOA@mail.gmail.com>
References: <20131128111557.6154.40370.stgit@nfdev.cica.es> <5297382F.60707@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:37156 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3K1NPv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:15:51 -0500
Received: by mail-la0-f44.google.com with SMTP id ep20so6098751lab.3
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 05:15:50 -0800 (PST)
In-Reply-To: <5297382F.60707@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28 November 2013 13:33, Tomasz Bursztyka
<tomasz.bursztyka@linux.intel.com> wrote:
>
> Why not reusing existing NFT_META_* keys?
> It would just raise an error if not priority/mark/nftrace/secmark, as=
 it
> does currently.
> Worth to keep that as it is imho, no need to duplicate.
>

That is a good approach, indeed.

My motivations for this was to give some additional flexibility, so
both keys sets don't depend on each other.
One may think you can simply modify other meta elements, like iifname, =
etc..

> All expression have a short, one-word based name, which is nice.

Yes, any suggestion?

>
> Anyway, doesn't it work already: if you create an immediate expressio=
n (to
> load the value you want, at default dreg 0 aka NFT_REG_VERDICT) and a=
 meta
> expression without the NFTA_META_DREG set? (didn't try myself)
>

I commented the immediate load with Pablo. He suggested the value to
be fetched from the metatarget directly.

> If not maybe there is a shorter way to fix this, instead of creating =
a full
> new expression. Looks like it was the original plan.
>

You mean the original plan was to avoid creating a new expression?
In that case, I will have to revisit this, as I wasn't considering
this approach.

Thanks Tomasz for your comments :-)

Regards.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
