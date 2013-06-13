From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 0/2] Series to add JSON output support for rules
Date: Thu, 13 Jun 2013 20:50:09 +0200
Message-ID: <20130613184810.423.11555.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60659 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020Ab3FMSuN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:50:13 -0400
Received: by mail-we0-f174.google.com with SMTP id q58so8267908wes.19
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2013 11:50:12 -0700 (PDT)
Received: from [127.0.1.1] (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id fv11sm33340804wic.11.2013.06.13.11.50.10
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 13 Jun 2013 11:50:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is the implementation for exporting the rules to JSON Format and f=
or testing the new functions

---

=C3=81lvaro Neira Ayuso (2):
      Add function for exporting rule to JSON format
      Add code for testing the new functions for exporting rules to JSO=
N Format


 examples/nft-rule-get.c    |    5 ++++
 include/libnftables/rule.h |    1 +
 src/expr/bitwise.c         |   33 ++++++++++++++++++++++++++++++
 src/expr/byteorder.c       |   21 +++++++++++++++++++
 src/expr/cmp.c             |   21 +++++++++++++++++++
 src/expr/counter.c         |    4 ++++
 src/expr/ct.c              |    5 ++++
 src/expr/data_reg.c        |   49 ++++++++++++++++++++++++++++++++++++=
++++++++
 src/expr/exthdr.c          |    7 ++++++
 src/expr/immediate.c       |   36 ++++++++++++++++++++++++++++++++
 src/expr/limit.c           |    4 ++++
 src/expr/log.c             |    7 ++++++
 src/expr/lookup.c          |   16 ++++++++++++++
 src/expr/match.c           |   25 ++++++++++++++++++++++
 src/expr/meta.c            |    4 ++++
 src/expr/nat.c             |   44 ++++++++++++++++++++++++++++++++++++=
++++
 src/expr/payload.c         |    6 +++++
 src/expr/target.c          |   26 +++++++++++++++++++++++
 src/internal.h             |    1 +
 src/rule.c                 |   44 ++++++++++++++++++++++++++++++++++++=
++++
 20 files changed, 358 insertions(+), 1 deletion(-)

--=20
=C3=81lvaro Neira Ayuso
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
