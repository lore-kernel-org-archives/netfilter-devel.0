From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 0/2] Series to add JSON output support for rules
Date: Thu, 27 Jun 2013 21:56:10 +0200
Message-ID: <20130627194837.13980.68301.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:61411 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab3F0T4O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:56:14 -0400
Received: by mail-we0-f175.google.com with SMTP id t59so891391wes.6
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2013 12:56:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Json support for exporting rules and add implementation for testing thi=
s functions. I have also ordered the switch case in the right order:
=46irst position: Default Support
Second position: Xml Support
Last position: Json Support

---

=C3=81lvaro Neira Ayuso (2):
      Add function for exporting rule to JSON format and Order the swit=
ch values in the right order
      Add code for testing the new functions for exporting rules to JSO=
N Format


 examples/nft-rule-get.c    |    5 +++
 include/libnftables/rule.h |    1 +
 src/chain.c                |    8 +++--
 src/expr/bitwise.c         |   37 ++++++++++++++++++++++++-
 src/expr/byteorder.c       |   22 +++++++++++++++
 src/expr/cmp.c             |   25 ++++++++++++++++-
 src/expr/counter.c         |    7 +++--
 src/expr/ct.c              |    5 +++
 src/expr/data_reg.c        |   65 ++++++++++++++++++++++++++++++++++++=
+++-----
 src/expr/exthdr.c          |   16 +++++++----
 src/expr/immediate.c       |   40 ++++++++++++++++++++++++++-
 src/expr/limit.c           |    4 +++
 src/expr/log.c             |    7 +++++
 src/expr/lookup.c          |   20 ++++++++++++--
 src/expr/match.c           |   18 +++++++++++-
 src/expr/meta.c            |   10 +++++--
 src/expr/nat.c             |   44 ++++++++++++++++++++++++++++--
 src/expr/payload.c         |   39 ++++++++++++++++++++++++--
 src/expr/target.c          |   19 ++++++++++++-
 src/internal.h             |    1 +
 src/rule.c                 |   52 ++++++++++++++++++++++++++++++++++-
 src/table.c                |    4 +--
 22 files changed, 406 insertions(+), 43 deletions(-)

--=20
=C3=81lvaro Neira Ayuso
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
