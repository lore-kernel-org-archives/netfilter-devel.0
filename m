From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [RFC nftables kernel PATCH] netfilter: nf_tables: fix
 nft_meta_target module
Date: Wed, 4 Dec 2013 16:05:53 +0100
Message-ID: <CAOkSjBjwJwBJkCKuLbHZARc5onGtUrfNz+9-wa+AyU-jZwx+SA@mail.gmail.com>
References: <20131128111557.6154.40370.stgit@nfdev.cica.es>
 <5297382F.60707@linux.intel.com> <CAOkSjBj+XER8sn1eakaTDyDJPUn=t50WFYLE8zF4uP7Ef9TTOA@mail.gmail.com>
 <529745ED.5050201@linux.intel.com> <20131204132119.GA13212@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:60023 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3LDPGR convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:06:17 -0500
Received: by mail-la0-f49.google.com with SMTP id er20so9561030lab.22
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Dec 2013 07:06:14 -0800 (PST)
In-Reply-To: <20131204132119.GA13212@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 December 2013 14:21, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
>
> @Arturo: Please, check nft_payload.c on how to use the select_ops API
> and let me know if you have any doubt. I can give you a hand on it.

Thanks, quite useful info.

I will be back with this as soon as I can.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
