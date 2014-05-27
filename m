From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH 0/2] Add DSCP and TOS support
Date: Tue, 27 May 2014 11:58:42 +0200
Message-ID: <1401184722-13929-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:42604 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaE0J70 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2014 05:59:26 -0400
Received: by mail-we0-f171.google.com with SMTP id w62so9384144wes.30
        for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2014 02:59:25 -0700 (PDT)
Received: from localhost.localdomain (186.169.216.87.static.jazztel.es. [87.216.169.186])
        by mx.google.com with ESMTPSA id mw4sm7021023wib.12.2014.05.27.02.59.23
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 May 2014 02:59:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patchset contains nftables updates:

1) Add support for using TOS symbols when we add rules that we use TOS.=
 Before,
we have added the rules with TOS mask and we didn't have support for ad=
ding
the rules with symbols.

2) Add support for using DSCP in Nftables. With this patch, we allow to=
 use
DSCP in nftables. With this two patchs, we have retrocompatibility with=
 TOS and
we have DSCP support.

3) We can add rules with TOS, but when we list the rules in nftables, t=
he
position in the Ip header of TOS and DSCP is the same (but different st=
ructure)
and we must to decide in which format we want to list the rules. I have=
 decided
to put the IPHDR_DSCP value before of IPHDR_TOS. With that we list the =
rules
with nftables, we will see the rules in format DSCP. I have decided tha=
t because
DSCP is more current and we still have retrocompatibility with TOS. Exa=
mple:

If we add this rule:

nft add rule ip filter input ip tos 0x00 counter accept

or

nft add rule ip filter input ip tos normal-service counter accept

If we list the table filter. We will see:

ip dscp CS0 counter packets 0 bytes 0 accept.

=C3=81lvaro Neira Ayuso (2):
  src: Add support for adding TOS symbols
  src: Add DSCP support in nftables

 include/datatype.h |    4 ++
 include/proto.h    |    1 +
 src/parser.y       |    2 +
 src/proto.c        |  133 ++++++++++++++++++++++++++++++++++++++++++++=
+++++++-
 src/scanner.l      |    1 +
 5 files changed, 140 insertions(+), 1 deletion(-)

--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
