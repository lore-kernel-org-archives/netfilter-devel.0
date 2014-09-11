From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nf-next 2/2] netfilter: masquerading needs to be
 independent of x_tables in Kconfig
Date: Thu, 11 Sep 2014 18:35:12 +0200
Message-ID: <CAOkSjBhtH5KOTubNwGzJ8dVn3h06ynFN=r7CrCEXL-5EXf5sZA@mail.gmail.com>
References: <1410451342-5746-1-git-send-email-pablo@netfilter.org> <1410451342-5746-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:44712 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaIKQfe convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:35:34 -0400
Received: by mail-lb0-f176.google.com with SMTP id z11so9509448lbi.21
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2014 09:35:33 -0700 (PDT)
In-Reply-To: <1410451342-5746-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11 September 2014 18:02, Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
> Users are starting to test nf_tables with no x_tables support. Theref=
ore,
> masquerading needs to be indenpendent of it from Kconfig.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Hi, my original intention was to nest the masquerade config under
NF_NAT_IPV[4|6].

I see now that I got confused between NF_NAT_IPV4 / IP_NF_NAT, and so o=
n.

Thanks for the fixes.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
