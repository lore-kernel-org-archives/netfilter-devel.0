From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] build: delete useless characters
Date: Wed, 16 Apr 2014 18:38:50 +0200
Message-ID: <CAOkSjBiF2pv5z+wvguL0bTkB2vB=s7QA9-X=koZYP689TjFWoQ@mail.gmail.com>
References: <20140416161038.1237.5216.stgit@nfdev.cica.es> <20140416163258.GA30296@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:36653 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaDPQjL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:39:11 -0400
Received: by mail-lb0-f178.google.com with SMTP id s7so8291294lbd.37
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Apr 2014 09:39:10 -0700 (PDT)
In-Reply-To: <20140416163258.GA30296@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16 April 2014 18:32, Patrick McHardy <kaber@trash.net> wrote:
>
> I assume you're on debian? The -e is needed to interpret the backslas=
h
> sequences like \t. Something is broken about the echo command in debi=
an,
> I'd assume its using the shell internal one instead of /bin/echo.
>

Yes, you are right. Then forget this patch.

I was reading a bit the build system, wondering how to get the actual
form of the CC commands.

regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
