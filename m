From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH, libmnl] Fix clang build issues in libmnl.
Date: Thu, 29 Oct 2015 15:26:43 +0100
Message-ID: <CAOkSjBhNk=gaVSuJa=tR64CBEDo2=UCC1Q=J0sF0EYEMkwjZew@mail.gmail.com>
References: <CABtf2+Tn6LUZCCbdbPx1o=-f2FgWPQ4k4DBiszACwoF_aQfLOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Caroline Tice <cmtice@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:33322 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbbJ2OfP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2015 10:35:15 -0400
Received: by wmeg8 with SMTP id g8so25519677wme.0
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2015 07:35:13 -0700 (PDT)
In-Reply-To: <CABtf2+Tn6LUZCCbdbPx1o=-f2FgWPQ4k4DBiszACwoF_aQfLOQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28 October 2015 at 21:46, Caroline Tice <cmtice@google.com> wrote:
> I recently found that if you try to build libmnl with clang it appear=
s
> to work correctly but most of the functions get built with the wrong
> visibility (which can cause them to be stripped/removed altogether
> from libmnl.so).
>

There is a related patch:

http://patchwork.ozlabs.org/patch/526607/

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
