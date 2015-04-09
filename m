From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH 1/4] include: cache a copy of kernel ebtables.h
Date: Thu, 9 Apr 2015 10:18:41 +0200
Message-ID: <CAOkSjBgmbim7fNMk1grB=SYn8JNhehPwWiooQN1DgCh8DHYtsQ@mail.gmail.com>
References: <20150408174818.28553.96128.stgit@nfdev2.cica.es> <20150408172249.49bbc646@urahara>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35813 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbbDIITD convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 04:19:03 -0400
Received: by lbbuc2 with SMTP id uc2so81911866lbb.2
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Apr 2015 01:19:01 -0700 (PDT)
In-Reply-To: <20150408172249.49bbc646@urahara>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 April 2015 at 02:22, Stephen Hemminger <stephen@networkplumber.org=
> wrote:
> On Wed, 08 Apr 2015 19:48:18 +0200
> Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
>
>> From: Arturo Borrero Gonzalez <aborrero@nfdev2.cica.es>
>>
>> Required for next patches.
>>
>> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.co=
m>
>
> If you are going to import a kernel header, it should be the exact ve=
rsion
> produced by doing:

Kernel patch: http://patchwork.ozlabs.org/patch/459393/

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
