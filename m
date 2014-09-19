From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft] the -nnn switch
Date: Fri, 19 Sep 2014 11:49:02 +0200
Message-ID: <CAOkSjBgOpbJmOXEX=a1kPXqDMs673ZTfB_Qg=q4V5L2JTsg77g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:62460 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaISJtZ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:49:25 -0400
Received: by mail-lb0-f175.google.com with SMTP id n15so2841167lbi.34
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Sep 2014 02:49:23 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

the -nnn switch in in nftables is IMO a bit annoying.
We are bounded to use that switch in every serious usage of nft.

Let me remember the current behaviour:

 -n -> don't translate IP addresses to names.
 -nn -> also, don't translate gids/uids to names.
 -nnn -> also, don't translate port numbers to names.
default -> translate all numbers to names.

I propose here that before nftables goes absolutely mainstream we
change the behaviour to the opposite:

-n -> translate IP addresses to names.
-nn -> translate gids/uids to names.
-nnn -> translate port numbers to names.
default -> show all numerically.

What do you think?

regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
