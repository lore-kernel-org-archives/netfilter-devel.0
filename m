From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft] segfault, bitmask datatype without parse() function
Date: Tue, 25 Nov 2014 13:53:20 +0100
Message-ID: <CAOkSjBhYt+tnDo7vP=bz5hP37cePGxvW2TApPtbXdA0FKkx9dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36265 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbaKYMxl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:53:41 -0500
Received: by mail-lb0-f177.google.com with SMTP id 10so449282lbg.8
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Nov 2014 04:53:40 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

It seems there is a segfault in nft.

How to reproduce:

% nft add rule inet filter ct state established,related accept

=3D=3D28442=3D=3D Jump to the invalid address stated on the next line
=3D=3D28442=3D=3D    at 0x0: ???
=3D=3D28442=3D=3D    by 0x4099EA: symbolic_constant_parse (datatype.c:1=
33)
=3D=3D28442=3D=3D    by 0x40BFD8: expr_evaluate (evaluate.c:199)
=3D=3D28442=3D=3D    by 0x40D524: list_member_evaluate (evaluate.c:597)
=3D=3D28442=3D=3D    by 0x40C25B: expr_evaluate (evaluate.c:649)
=3D=3D28442=3D=3D    by 0x40C103: expr_evaluate (evaluate.c:879)
=3D=3D28442=3D=3D    by 0x40D908: stmt_evaluate (evaluate.c:1103)
=3D=3D28442=3D=3D    by 0x40DF27: rule_evaluate (evaluate.c:1727)
=3D=3D28442=3D=3D    by 0x40E0A6: chain_evaluate (evaluate.c:1788)
=3D=3D28442=3D=3D    by 0x40E4CE: cmd_evaluate (evaluate.c:1807)
=3D=3D28442=3D=3D    by 0x423757: nft_parse (parser_bison.y:549)
=3D=3D28442=3D=3D    by 0x4061CC: nft_run (main.c:231)
=3D=3D28442=3D=3D  Address 0x0 is not stack'd, malloc'd or (recently) f=
ree'd
=3D=3D28442=3D=3D
=3D=3D28442=3D=3D
=3D=3D28442=3D=3D Process terminating with default action of signal 11 =
(SIGSEGV)
=3D=3D28442=3D=3D  Bad permissions for mapped region at address 0x0
=3D=3D28442=3D=3D    at 0x0: ???
=3D=3D28442=3D=3D    by 0x4099EA: symbolic_constant_parse (datatype.c:1=
33)
=3D=3D28442=3D=3D    by 0x40BFD8: expr_evaluate (evaluate.c:199)
=3D=3D28442=3D=3D    by 0x40D524: list_member_evaluate (evaluate.c:597)
=3D=3D28442=3D=3D    by 0x40C25B: expr_evaluate (evaluate.c:649)
=3D=3D28442=3D=3D    by 0x40C103: expr_evaluate (evaluate.c:879)
=3D=3D28442=3D=3D    by 0x40D908: stmt_evaluate (evaluate.c:1103)
=3D=3D28442=3D=3D    by 0x40DF27: rule_evaluate (evaluate.c:1727)
=3D=3D28442=3D=3D    by 0x40E0A6: chain_evaluate (evaluate.c:1788)
=3D=3D28442=3D=3D    by 0x40E4CE: cmd_evaluate (evaluate.c:1807)
=3D=3D28442=3D=3D    by 0x423757: nft_parse (parser_bison.y:549)
=3D=3D28442=3D=3D    by 0x4061CC: nft_run (main.c:231)
=3D=3D28442=3D=3D

As far as I've investigated, it seems the bitmask datatype is missing
somehow the parse() function.

My HEAD is cf1e7d4 (netlink: don't bug on unknown events).

regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
