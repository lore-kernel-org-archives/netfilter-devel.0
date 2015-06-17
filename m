From: Miroslav Kratochvil <exa.exa@gmail.com>
Subject: Re: [PATCH nft] parser_bison: allow to use mark as datatype for maps
 and sets
Date: Wed, 17 Jun 2015 10:29:30 +0200
Message-ID: <CAO0uZ+-k7FVjpforphDBLEnLEpxMj8uSnQWOTeFvVzSRonWpUg@mail.gmail.com>
References: <1434469933-6402-1-git-send-email-pablo@netfilter.org>
	<20150616154924.GL20951@acer.localdomain>
	<20150616155732.GA7067@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36741 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbbFQI3c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 04:29:32 -0400
Received: by lbbqq2 with SMTP id qq2so26376085lbb.3
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 01:29:31 -0700 (PDT)
In-Reply-To: <20150616155732.GA7067@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> > Yes, I think this is preferrable since the mark type can be used for
> > things besides packet marking, f.i. conntracks.
>
> Ok, then I'll push this patch, thanks!


Great, marking by named map is now perfectly usuable.

One last (cosmetic reminder) thing, could the last occurence of
"packetmark" type name in documentation also be replaced with "mark",
for consistency?

in doc/nft.xml, lines 988, 1887.

Many thanks to you both.
-mk
