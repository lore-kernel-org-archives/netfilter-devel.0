From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] parsing: add interface to parse from file
Date: Thu, 2 Jan 2014 19:47:38 +0100
Message-ID: <CAOkSjBg9tS38QWAhR+pZsV5639gYneEjApcqBM9t-rW6W9DQsA@mail.gmail.com>
References: <20140102132103.23299.58753.stgit@nfdev.cica.es> <20140102135242.GA5101@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:46821 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaABSr7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:47:59 -0500
Received: by mail-la0-f52.google.com with SMTP id y1so7348827lam.25
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Jan 2014 10:47:58 -0800 (PST)
In-Reply-To: <20140102135242.GA5101@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2 January 2014 14:52, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Please, rework this to pass a file descriptor instead so it's
> consistent with _fprintf API and we can use it with pipes as well.

Should I do a fread() based input?:

size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);

If so, the API func may look like:

int nft_chain_fparse(struct nft_chain *c, type, size_t size, FILE *stre=
am);

And then I will need to malloc(size).

Is this OK?

regards.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
