From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: nft shell tests
Date: Thu, 23 Jun 2016 12:53:54 +0200
Message-ID: <CAOkSjBgP8x8BY-9J5Vj69Su8oR8B4scoxXY77rwAGZkEXNDpog@mail.gmail.com>
References: <20160623104320.GA13710@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34877 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbcFWKyP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 06:54:15 -0400
Received: by mail-wm0-f41.google.com with SMTP id v199so121395007wmv.0
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 03:54:14 -0700 (PDT)
In-Reply-To: <20160623104320.GA13710@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23 June 2016 at 12:43, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> Hi Arturo,
>
> I think it would be good if the run-test.sh script uses the binary
> in this tree, just like nft-tests.py. Instead of using the one that i=
s
> available on the system.
>
> Let me know, thanks.

You can use arbitrary binaries passing the NFT variable:

% NFT=3D../../src/nft ./run-tests.sh

would you like to change the behaviour to use the nft binary from src/
by default?

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
