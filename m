From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft] segfault in expr_clone()
Date: Tue, 6 Oct 2015 10:58:08 +0200
Message-ID: <CAOkSjBgHradNUToxoUdQ_6H3yyUaGSJ=4RroZTxBLtAcGdz7bw@mail.gmail.com>
References: <CAOkSjBgyW232aqidQ-EPPinpAqkd21pjqV3W0VE_0N3RVL89pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34531 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbbJFI63 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Oct 2015 04:58:29 -0400
Received: by wicfx3 with SMTP id fx3so155809482wic.1
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2015 01:58:28 -0700 (PDT)
In-Reply-To: <CAOkSjBgyW232aqidQ-EPPinpAqkd21pjqV3W0VE_0N3RVL89pg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6 October 2015 at 10:48, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> Hi,
>
> debian users are reporting [0] a segfault related to expr_clone().
>
> Is this the issue fixed by Florian's patch [1] ?

Ok, I've checked myself. Florian's patch address the issue.

regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
