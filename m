From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf-next/nf_tables8] Unable to compile kernel
Date: Mon, 18 Feb 2013 17:39:49 +0100
Message-ID: <CAOkSjBh78knOWQLmFnz+XyW4umVVnVVkWs9VeYPJdzhxg3T_fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pneira@us.es>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:33878 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3BRQkK convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:40:10 -0500
Received: by mail-vc0-f176.google.com with SMTP id fk10so3622648vcb.7
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Feb 2013 08:40:09 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there,

I'm unable to compile the nf-next (branch nf_tables8) kernel:

[...]
  CC      init/version.o
  LD      init/built-in.o
net/built-in.o: In function `nft_exthdr_eval':
/home/aborrero/git/nf-next/net/netfilter/nft_exthdr.c:37: undefined
reference to `ipv6_find_hdr'
net/built-in.o: In function `nft_set_pktinfo_ipv6':
/home/aborrero/git/nf-next/include/net/netfilter/nf_tables_ipv6.h:18:
undefined reference to `ipv6_find_hdr'
/home/aborrero/git/nf-next/include/net/netfilter/nf_tables_ipv6.h:18:
undefined reference to `ipv6_find_hdr'
/home/aborrero/git/nf-next/include/net/netfilter/nf_tables_ipv6.h:18:
undefined reference to `ipv6_find_hdr'
make[2]: *** [vmlinux] Error 1
[...]

This is the code: http://1984.lsi.us.es/git/nf-next/tree/?h=3Dnf_tables=
8

Could anyone give me some hints of what should I do to fix it?

Regards.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
