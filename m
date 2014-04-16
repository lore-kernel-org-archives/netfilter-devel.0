From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: nftables v0.2 doesn't build with libnftnl v1.0.0
Date: Wed, 16 Apr 2014 14:46:25 +0200
Message-ID: <CAOkSjBikNo+m5w0tCEin+JUeKoy6JdE9V4jyiym2p7DizXvn4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:58720 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaDPMqr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:46:47 -0400
Received: by mail-la0-f54.google.com with SMTP id mc6so8262340lab.27
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Apr 2014 05:46:45 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there!

nftables v0.2 needs latest libnftnl to build.

When using libnftnl v1.0.0 I get:

[...]
src/netlink.c: In function =E2=80=98alloc_nft_rule=E2=80=99:
src/netlink.c:124:3: warning: implicit declaration of function
=E2=80=98nft_rule_attr_set_data=E2=80=99 [-Wimplicit-function-declarati=
on]
src/netlink.c:124:31: error: =E2=80=98NFT_RULE_ATTR_USERDATA=E2=80=99 u=
ndeclared
(first use in this function)
src/netlink.c:124:31: note: each undeclared identifier is reported
only once for each function it appears in
[...]

Would you please release a new version of libnftnl?

thanks, regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
