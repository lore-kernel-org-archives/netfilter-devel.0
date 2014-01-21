From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Can't compile nftables
Date: Tue, 21 Jan 2014 13:26:41 +0100
Message-ID: <CAOkSjBiG2dXFKves3yf61Lw2gP=EBC=auAaTJL8HApGmc8O7PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:59186 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbaAUM1D convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:27:03 -0500
Received: by mail-lb0-f172.google.com with SMTP id c11so5940482lbj.31
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2014 04:27:01 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there,

I have this:

% make clean && make -j8 && make install

-e   CC src/parser.c
-e   CC src/scanner.c
-e   LD src/nft
src/scanner.o: In function `nft_realloc':
/home/aborrero/git/nftables/<stdout>:4146: undefined reference to `rpl_=
realloc'
src/scanner.o: In function `nft_alloc':
/home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_=
malloc'
/home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_=
malloc'
/home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_=
malloc'
src/scanner.o: In function `nft_realloc':
/home/aborrero/git/nftables/<stdout>:4146: undefined reference to `rpl_=
realloc'
/home/aborrero/git/nftables/<stdout>:4146: undefined reference to `rpl_=
realloc'
src/scanner.o: In function `nft_alloc':
/home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_=
malloc'
/home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_=
malloc'
/home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_=
malloc'
/home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_=
malloc'
/home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_=
malloc'
src/scanner.o: In function `nft_realloc':
/home/aborrero/git/nftables/<stdout>:4146: undefined reference to `rpl_=
realloc'
src/utils.o: In function `xmalloc':
/home/aborrero/git/nftables/src/utils.c:36: undefined reference to `rpl=
_malloc'
src/utils.o: In function `xrealloc':
/home/aborrero/git/nftables/src/utils.c:44: undefined reference to `rpl=
_realloc'
src/parser.o: In function `nft_parse':
/home/aborrero/git/nftables/src/parser.c:3183: undefined reference to
`rpl_malloc'
/home/aborrero/git/nftables/src/parser.c:6193: undefined reference to
`rpl_malloc'
collect2: error: ld returned 1 exit status

Do you have any idea of why?

my git: 11ba325 (HEAD, origin/master, origin/HEAD, master) bump
release number to 0.100

thanks.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
