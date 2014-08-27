From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf_tables PATCH v4 4/5] helpers
Date: Wed, 27 Aug 2014 09:54:15 +0200
Message-ID: <CAOkSjBjV5ZJgqGCudbShfv8QuTTM+Jv4XmZ=qb3TZSvMb1Q8pw@mail.gmail.com>
References: <20140827072217.2762.69989.stgit@nfdev.cica.es> <20140827072447.2762.61934.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:40065 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaH0Hyh convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:54:37 -0400
Received: by mail-la0-f54.google.com with SMTP id hz20so16375296lab.13
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2014 00:54:35 -0700 (PDT)
In-Reply-To: <20140827072447.2762.61934.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27 August 2014 09:25, Arturo Borrero Gonzalez
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

The title of the patch is 'netfilter: nf_tables: add helpers to
schedule objects deletion'.

Could you please Pablo amend it?

thanks.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
