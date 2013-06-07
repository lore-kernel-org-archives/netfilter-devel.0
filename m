From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 0/2] Series short description
Date: Fri, 07 Jun 2013 11:14:02 +0200
Message-ID: <20130607091043.13002.66552.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64206 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3FGJOM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:14:12 -0400
Received: by mail-wg0-f43.google.com with SMTP id x12so2843026wgg.34
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Jun 2013 02:14:10 -0700 (PDT)
Received: from [127.0.1.1] (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id u9sm1855800wif.6.2013.06.07.02.14.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 07 Jun 2013 02:14:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements...

I collapsed the patches. Now, you can compile libnftables without error=
 if you apply the patch.

I hope everything is correct.

Thanks for all.

---

Alvaro Neira (2):
      Add functions for exporting tables to JSON format
      Add implementation for to proof the JSON export function


 examples/nft-table-get.c    |    4 ++++
 include/libnftables/table.h |    1 +
 src/internal.h              |    1 +
 src/table.c                 |   18 ++++++++++++++++++
 4 files changed, 24 insertions(+)

--=20
=C3=81lvaro Neira Ayuso
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
