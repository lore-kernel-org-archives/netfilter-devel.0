From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: nftables next-3.14 merged into master
Date: Mon, 17 Feb 2014 22:22:33 +0100
Message-ID: <CAOkSjBiwM0zX6q51rE9ysiJ9B1YFNB=tYJNwctjvgKjgoLUt9Q@mail.gmail.com>
References: <20140217194156.GC11041@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:57712 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaBQVWy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:22:54 -0500
Received: by mail-la0-f54.google.com with SMTP id y1so11755776lam.13
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2014 13:22:53 -0800 (PST)
In-Reply-To: <20140217194156.GC11041@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17 February 2014 20:41, Patrick McHardy <kaber@trash.net> wrote:
> Just a heads up, I've merged the next-3.14 branch into master, which =
is
> where things will be happening from now on. Please make sure to switc=
h
> branches if you're on next-3.14.

Something weird happened:

[...]
413eded src: proto: fixed a rreply symbol
b621a41 src: proto: fixed a rreply symbol
[...]

The first one with no content.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
