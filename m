From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [conntrack-tools PATCH] nfct: don't link against libnetfilter_conntrack
Date: Fri, 21 Aug 2015 08:54:00 +0200
Message-ID: <CAOkSjBjWKU_T6+nmXRnOS9EqQmpu49wtxrXFQFYgV4LUG4XbxQ@mail.gmail.com>
References: <20150820113841.3543.68437.stgit@nfdev2.cica.es> <alpine.LSU.2.20.1508202029210.27052@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:33878 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbbHUGyW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Aug 2015 02:54:22 -0400
Received: by laba3 with SMTP id a3so35938416lab.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2015 23:54:20 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.20.1508202029210.27052@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20 August 2015 at 20:30, Jan Engelhardt <jengelh@inai.de> wrote:
> On Thursday 2015-08-20 13:38, Arturo Borrero Gonzalez wrote:
>
>>The nfct program uses none of the symbols of libnetfilter_conntrack.
>>
>>Linking against it means that distributors have to maintain an useles=
s
>>depedency.
>
> Not to say the patch is bad, but:
> Distributions do not really have to maintain a dependency anyway,
> as it can be autodiscovered from the DT_NEEDED entries. In addition,
> conntrackd still uses the library, so a dependency in the package
> will stay around.

In case of debian, there are 3 different binary packages for
conntrack, conntrackd and nfct. Each package may have different
dependencies.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
