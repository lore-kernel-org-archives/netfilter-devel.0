From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf_tables PATCH v3 4/5] netfilter: nf_tables: add helpers to
 schedule objects deletion
Date: Tue, 26 Aug 2014 17:11:55 +0200
Message-ID: <CAOkSjBgGPkXiLObGpEcu6UjJEGw4G+wieEGpxQ664hU+5pD7DA@mail.gmail.com>
References: <20140826150500.3669.95959.stgit@nfdev.cica.es> <20140826150711.3669.25631.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:34616 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933975AbaHZPMR convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:12:17 -0400
Received: by mail-la0-f52.google.com with SMTP id b17so14857932lan.25
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2014 08:12:16 -0700 (PDT)
In-Reply-To: <20140826150711.3669.25631.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26 August 2014 17:07, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> This patch refactor the code to schedule objects deletion.
>
> They are useful in follow-up patches.
>
> In order to be able to use these new helper functions in all the code=
,
> they are placed in the top of the file, with all the dependant functi=
ons
> and symbols.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com=
>
> ---
> v2: rebased: now, nft_del*() functions use list_del_rcu().
> v3: rebased on top of patch 1/5.
>

Oops, please forget this patch. I sent the wrong series, with this
patch in bad state.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
