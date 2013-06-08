From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 0/2] Series short description
Date: Sat, 08 Jun 2013 15:35:56 +0200
Message-ID: <20130608133222.10197.21456.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:54471 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3FHNgA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 09:36:00 -0400
Received: by mail-we0-f182.google.com with SMTP id p60so2043808wes.41
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Jun 2013 06:35:59 -0700 (PDT)
Received: from [127.0.1.1] (89.153.20.95.dynamic.jazztel.es. [95.20.153.89])
        by mx.google.com with ESMTPSA id cw8sm2322187wib.7.2013.06.08.06.35.58
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 08 Jun 2013 06:35:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the implementation for exporting chains to JSON Format and for to t=
est=20
the function.

---

Alvaro Neira Ayuso (2):
      Add function for exporting chain to JSON Format
      Implementation for to test the function for exporting chains to J=
SON format


 examples/nft-chain-get.c    |    5 ++++-
 include/libnftables/chain.h |    1 +
 src/chain.c                 |   27 +++++++++++++++++++++++++++
 src/internal.h              |    1 +
 4 files changed, 33 insertions(+), 1 deletion(-)

--=20
=C3=81lvaro Neira Ayuso
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
