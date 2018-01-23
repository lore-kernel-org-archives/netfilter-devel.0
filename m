From: David Fabian <david.fabian@cldn.cz>
Subject: Re: question about UNDEFINE/REDEFINE
Date: Tue, 23 Jan 2018 13:40:03 +0100
Message-ID: <1993002.08LkLsM8EI@voxel>
References: <3622208.jy4NlOniyd@voxel> <20180123110728.i7hujeyz6224atd2@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailalternative.uvtmail.cz ([109.205.75.52]:59025 "EHLO
        mail.hosting.cldn.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751056AbeAWMkG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 07:40:06 -0500
In-Reply-To: <20180123110728.i7hujeyz6224atd2@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

Dne =C3=BAter=C3=BD 23. ledna 2018 12:07:28 CET, Pablo Neira Ayuso napsal(a=
):
> I'm asking here because I would need to understand better how you've
> structured your scripts, if you could explain a bit more, we would
> appreciate.

I have packed an excerpt of a playground FW with two VLANs 3 and 54. The=20
configuration already uses my redefine keyword.

ftp://ftp.bosson.eu/pub/tmp/nftables_excerpt.tar.gz

The intended use case is to call nft -f fw-on and reload the firewall from=
=20
scratch every time there is a config change. I don't know how a cmdline=20
parameter would help us with it. Maybe if we would wrap nft calls with bash=
=20
scripts but that would defeat the purpose of using the nft scripting=20
capabilities in the first place.

The most important for us is to have the FW logically structured for every=
=20
customer and every FW rule related to a customer should be in his/her VLAN=
=20
config file.

=2D-=20
Best regards,

David Fabian
Cluster Design, s.r.o.

