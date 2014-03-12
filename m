From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: some minor tweaks for building doc/man pages for nftables
Date: Wed, 12 Mar 2014 12:14:02 +0100
Message-ID: <CAOkSjBjJ7f_ANknUa3ojoaHF_+meYFe1dkOCBzOBFdAC3pxxkA@mail.gmail.com>
References: <alpine.LFD.2.11.1403120529570.4122@localhost> <CAOkSjBiKQHg7TYU_nQmNgtC_fzybe3LOLsO-JktJx=7oQsYBCQ@mail.gmail.com>
 <alpine.LFD.2.11.1403120701510.5974@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter devel list <netfilter-devel@vger.kernel.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:47774 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbaCLLOc convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:14:32 -0400
Received: by mail-la0-f53.google.com with SMTP id b8so6590687lan.12
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2014 04:14:22 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.11.1403120701510.5974@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 March 2014 12:03, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>   quite possibly some of it, but surely the "nftables.xml" file under
> doc/ should be updated to reflect that the command is now "nft", not
> "nftables", no?
>

In Debian, my plan is to provide the same man page both for 'nft' and
'nftables' (one being a symlink to the other).

>   anyway, i'll leave this in the hands of the powers-that-be on this
> list.
>

In the docbook side, you could try to find a solution that covers
all/most-important distributions.
I would suggest to simply send patches so we can review your ideas.

regards.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
