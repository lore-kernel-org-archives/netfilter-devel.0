From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [RFC nft] meta: deprecate unqualified meta statements
Date: Wed, 27 Jul 2016 09:36:30 +0200
Message-ID: <CAOkSjBhA-Xok-XmxbYqHqDiwnCXfNFTP-KoXgL8A-+BQsOoxDw@mail.gmail.com>
References: <1469585853-6207-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37419 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbcG0Hgv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Jul 2016 03:36:51 -0400
Received: by mail-wm0-f52.google.com with SMTP id i5so48379638wmg.0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jul 2016 00:36:50 -0700 (PDT)
In-Reply-To: <1469585853-6207-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27 July 2016 at 04:17, Florian Westphal <fw@strlen.de> wrote:
> During NFWS we discussed reducing the number of keywords in nftables.
>
> Obviously keywords are required for the parser to know what to expect=
=2E
>
> But always requiring the 'meta' keyword would allow us to handle
> iif, oif, iifname etc without defining them in the scanner, i.e. we
> could later use 'meta STRING' and resolve/map the keyword at run time
> based on the meta template pseudo-header.
>
> Note that this change does not yet reject 'iif eth0', this only makes
> nft always print the 'meta' keyword when listing and updates the test
> cases as required.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>

If we are to break the syntax sooner or later, I would ask to be as
soon as possible.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
