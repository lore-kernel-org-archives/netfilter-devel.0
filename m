From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH 3/3 v2] src: add list ruleset command
Date: Wed, 24 Sep 2014 16:54:10 +0200
Message-ID: <CAOkSjBjRPH3hDJrVY5YPn0Db8vQgPZxdnHoPhrHHW90wjvz0vQ@mail.gmail.com>
References: <1411554740-16660-1-git-send-email-arturo.borrero.glez@gmail.com> <1411554740-16660-3-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:49241 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaIXOye convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:54:34 -0400
Received: by mail-la0-f52.google.com with SMTP id gq15so10639699lab.25
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2014 07:54:30 -0700 (PDT)
In-Reply-To: <1411554740-16660-3-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24 September 2014 12:32, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> This patch adds a new command to nft:
>         % nft list ruleset [family]
>

Hi,

this patch requires further review and tuning.

When using the interactive mode there are weird behaviours I need to
investigate.
Any pointer will be appreciated.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
