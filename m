From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: nft compat layer
Date: Fri, 15 Jan 2016 21:06:35 +0100
Message-ID: <CAOkSjBhpqYQ01xOehhG7zFAzStOcTttQTk1JcLaP_UnAWSzmPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Shivani Bhardwaj <shivanib134@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37254 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbcAOUGz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2016 15:06:55 -0500
Received: by mail-wm0-f54.google.com with SMTP id f206so41170889wmf.0
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2016 12:06:55 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm giving a spin to the nft compat layer, since it can be of certain
importance for distributions.

I just want to be clear on what I recommends to end users about
migrating from iptables (and friends) to nftables.

Could you please remind me in which state was the discussion about
that patch to show x_tables extensions in nftables rulesets [0]?
I remember Patrick mentioned several concerns back then about this appr=
oach.

Currently, with a basic ruleset errors are shown [1]. Also, if you try
to see what's happening, segfaults [2].

I'm aware of the translations efforts being made by Shivani.

[0] http://patchwork.ozlabs.org/patch/459398/
[1] http://paste.debian.net/366059
[2] http://paste.debian.net/366060/

best regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
