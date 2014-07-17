From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH] common: events: be more strict when placing the
 \0 character
Date: Thu, 17 Jul 2014 10:16:24 +0200
Message-ID: <CAOkSjBjqV2QdHtHtwKAk40KRZjoM1W4rTqst-fjE+Qz91siReQ@mail.gmail.com>
References: <20140714124335.13205.77982.stgit@nfdev.cica.es> <20140715164242.GA11248@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:55761 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbaGQIQq convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:16:46 -0400
Received: by mail-lb0-f178.google.com with SMTP id c11so577913lbj.9
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jul 2014 01:16:45 -0700 (PDT)
In-Reply-To: <20140715164242.GA11248@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15 July 2014 18:42, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> BTW, could you review all_snprintf functions? We should retain the
> snprintf semantics, ie. always nul-terminate strings if
>
>         offset < buffer_size
>
> Otherwise, return the string without the nul-termination.

Sure, thanks.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
