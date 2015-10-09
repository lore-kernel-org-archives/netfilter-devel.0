From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft] possible several bugs in maps
Date: Fri, 9 Oct 2015 11:35:32 +0200
Message-ID: <CAOkSjBh6Pt79--f8nOmS_kQgbHhQaWBsXdj88tnV3hUTEuYOGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Florian Westphal <fw@strlen.de>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33396 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbbJIJfx convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Oct 2015 05:35:53 -0400
Received: by wiclk2 with SMTP id lk2so62483572wic.0
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Oct 2015 02:35:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

i'm playing with nftables maps and found some issues.

=46irst:

I can add this named map in the CLI but I can't load it from a file.
This can be reproduced with these commands:

% nft flush ruleset
% nft add table t
% nft add map t m { type ipv4_addr : ipv4_addr ; }
% nft add element t m {1.1.1.1: 2.2.2.2 }
% echo "flush ruleset" > test.nft
% nft list ruleset >> test.nft
% nft -f test.nft
test.nft:5:28-46: Error: mapping outside of map context
            elements =3D { 1.1.1.1 : 2.2.2.2}
                        ^^^^^^^^^^^^^^^^^^^

Second:

I can use ANONYMOUS maps for SNAT:

% nft flush ruleset
% nft add table nat
% nft add chain nat postrouting
% nft add rule nat postrouting snat ip saddr map {1.1.1.1 : 2.2.2.2}
[OK]

But I can't use NAMED maps for SNAT:

% nft flush ruleset
% nft add table nat
% nft add map nat m { type ipv4_addr : ipv4_addr\; }
% nft add element nat m { 1.1.1.1 : 2.2.2.2 }
% nft add chain nat postrouting
% nft add rule nat postrouting snat ip saddr map @m
<cmdline>:1:1-45: Error: Could not process rule: Invalid argument
add rule nat postrouting snat ip saddr map @m
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This seems to be triggered by the kernel (I'm running 4.1, please let
me know if newer versions has this fixed)

best regards!
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
