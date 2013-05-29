From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH v2] src: xml: add versioning
Date: Thu, 30 May 2013 00:56:46 +0200
Message-ID: <CAOkSjBjgWjYX8a-VZAvMvyH69pbLJqYJXYzruZjNjnCeRG5C0g@mail.gmail.com>
References: <20130527171634.4562.53398.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:51548 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966998Ab3E2W5J convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 18:57:09 -0400
Received: by mail-la0-f52.google.com with SMTP id fo13so9305167lab.11
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2013 15:57:07 -0700 (PDT)
In-Reply-To: <20130527171634.4562.53398.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/5/27 Arturo Borrero <arturo.borrero.glez@gmail.com>:
> All XML chunks now have a "version" attribute to help in future chang=
es.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com=
>
> ---
>  src/chain.c    |   18 +++++++++++++++---
>  src/internal.h |    4 ++++
>  src/rule.c     |   17 +++++++++++++++--
>  src/table.c    |   18 ++++++++++++++++--
>  4 files changed, 50 insertions(+), 7 deletions(-)

Hi,

I see this at patchwork as accepted, but is not in git.netfilter.org.

http://patchwork.ozlabs.org/patch/246629/

should I continue working with 'version' attributes?

regards.

--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
