From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] parser: simplify monitor command parsing
Date: Wed, 17 Sep 2014 09:52:11 +0200
Message-ID: <CAOkSjBgHZ4aG7Qog1pOtCHS=YDmLiJi11eXPxdY20oDNgPE1bA@mail.gmail.com>
References: <1410939907-10180-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:51089 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaIQHwf convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:52:35 -0400
Received: by mail-la0-f43.google.com with SMTP id gi9so1325476lab.30
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Sep 2014 00:52:31 -0700 (PDT)
In-Reply-To: <1410939907-10180-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17 September 2014 09:45, Patrick McHardy <kaber@trash.net> wrote:
> Add tokens for "new" and "destroy". Split up the monitor flags into a=
n
> event and an object to avoid lots of duplicated code.
>
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> ---

I think the 'new' keyword may clash with 'ct new', don't you?. That's
why Pablo did the parser that way.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
