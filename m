From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: Re: ulogd - rpm file generation
Date: Thu, 19 Jul 2012 12:34:44 -0700
Message-ID: <CAAJpzgaM3KpsDuS6SpUWQjTTQtgfpGO4B8Ok3hH61SXqYtdkrw@mail.gmail.com>
References: <CAAJpzga1LexHUgL5aqF26ukUEsGy0AojRYqLO5ONqv71nLUedg@mail.gmail.com>
 <alpine.LNX.2.01.1207192122200.5668@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35971 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2GSTfG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:35:06 -0400
Received: by gglu4 with SMTP id u4so3185315ggl.19
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jul 2012 12:35:05 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1207192122200.5668@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thank you, Does netfilter maintain the rpms for different
architectures somewhere?
In the netfilter website, I am not able to see them, other than tar files.

I would be happy if I am able to download all the rpms for ulogd & its
dependencies for x86_64 architecture. It will help to speed up my
work.
I am not able to find them in rpmfind website.

Thanks & Regards,




On Thu, Jul 19, 2012 at 12:23 PM, Jan Engelhardt <jengelh@inai.de> wrote:
> On Thursday 2012-07-19 19:57, Gomathivinayagam Muthuvinayagam wrote:
>
>>Hi,
>>
>>I'm trying to build ulogd rpm file for a system x86_64 architecture.
>>There is a spec file provided in ulogd tar file.
>>Can I use that and build it? Is it updated one? Or still I have to go
>>through Makefile and find out if anything is missing?
>>
>>Please bear with me, I'm trying to build rpm for the first time.
>
> Doubtful that it is still current.
> What is current though, is
> http://build.opensuse.org/package/show?package=ulogd&project=security:netfilter
