From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 6/6] tests: update tests with nft_*_parse_file()
Date: Wed, 8 Jan 2014 13:21:56 +0100
Message-ID: <CAOkSjBiQ4AbeD3dpR+4h+aO7PeMX6FGym1CxNu0xuMuVz82k4g@mail.gmail.com>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
 <20140107114742.12841.61774.stgit@nfdev.cica.es> <20140107233219.GE16894@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:39140 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbaAHMWS convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:22:18 -0500
Received: by mail-la0-f43.google.com with SMTP id n7so1094030lam.30
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jan 2014 04:22:16 -0800 (PST)
In-Reply-To: <20140107233219.GE16894@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 8 January 2014 00:32, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> This was fine in an early stage, but now that you have the ruleset
> API, we should provide a nft_ruleset_parse_file(...) function that do
> all this for you. As a side effect, the test will be simplified.
>

good point. I will rework this.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
