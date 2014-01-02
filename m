From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] expr: add ct_set expression
Date: Thu, 2 Jan 2014 12:20:52 +0100
Message-ID: <CAOkSjBhah=-vCfAz6+B9hxZiiez30Fy=Zg7H=+mVRVHMxE4S1A@mail.gmail.com>
References: <1388653976-30802-1-git-send-email-eric@regit.org>
 <1388654079-31459-1-git-send-email-eric@regit.org> <CAOkSjBg5C6eCQ-AA-E5Wr9wExo8hZsEk3Bz2G5BPpqAVHBtoGA@mail.gmail.com>
 <1388657724.29019.5.camel@ice-age2.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:48920 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaABLVO convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:21:14 -0500
Received: by mail-la0-f50.google.com with SMTP id el20so7142315lab.37
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Jan 2014 03:21:12 -0800 (PST)
In-Reply-To: <1388657724.29019.5.camel@ice-age2.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2 January 2014 11:15, Eric Leblond <eric@regit.org> wrote:
>> I guess either this or the others aren't good, don't you?
>
> No ;)
>

Ok!

>>
>> I will patch nft_mxml_expr_parse() and nft_jansson_expr_parse().
>
> Good catch!
>

=46alse-positive, they do set errno through concrete helpers, like
nft_xx_reg_parse() etc..

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
