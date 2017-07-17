From: Julian Anastasov <ja@ssi.bg>
Subject: [PATCHv2 -stable 0/3] ipvs: patches for stable
Date: Mon, 17 Jul 2017 09:59:50 +0300
Message-ID: <20170717065953.23403-1-ja@ssi.bg>
Cc: netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        lvs-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ja.ssi.bg ([178.16.129.10]:56498 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751256AbdGQHHF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 03:07:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

	Hello,

The following patches are backports for commit 3c5ab3f395d6
("ipvs: SNAT packet replies only for NATed connections")
which comes with 4.12.

Patch 1: 3.2.90, 3.4.113
Patch 2: 3.10.107, 3.16.45, 4.1.42
Patch 3: 4.4.77

The original commit can be directly applied to 4.9.38 and 4.11.11
