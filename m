From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nft] expression: provide clone operation for set element ops
Date: Tue, 6 Oct 2015 10:58:59 +0200
Message-ID: <CAOkSjBgNSz4+k=bDVsfsabYAH26LDOYY65A_PQYmFz+HcYWzVA@mail.gmail.com>
References: <1443653206-25841-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34807 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbbJFI7U convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Oct 2015 04:59:20 -0400
Received: by wicfx3 with SMTP id fx3so155841660wic.1
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2015 01:59:19 -0700 (PDT)
In-Reply-To: <1443653206-25841-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 1 October 2015 at 00:46, Florian Westphal <fw@strlen.de> wrote:
> define addrs=3D{ 1.2.3.4 }
> table ip filter {
>         chain input {
>                 type filter hook input priority 0;
>                 ip saddr $addrs accept
>         }
> }
>
> segfaults. Using saddr { 1.2.3.4 } instead of $addrs works.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/expression.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>

Tested-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
