Return-Path: <SRS0=SOhW=3T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1F8C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53F47206A2
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:16:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CwITr/QR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgA3AQp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 19:16:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23393 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726671AbgA3AQp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 19:16:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580343404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u7buwLtbPQ0gweUHBYDRALUowEyyvUfOjG1KTupzyWU=;
        b=CwITr/QRwDeMkZrY0vYf9q1FlgicMPTtdUr/+tpLePHCyGS3aPpPL0wzc5l03yWiLfv4GK
        XB54NERksbowQf5MH1VwU0zXSNkj4IdMYVVQ1ysOQ2Zgq5C+GWBPAFIhuxDWqUrT5wauzb
        hXKaXyXvbYXhuXseZF0PYuLE5K7PW2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-6qhn4tUCP_ibBpO9sLsXHQ-1; Wed, 29 Jan 2020 19:16:39 -0500
X-MC-Unique: 6qhn4tUCP_ibBpO9sLsXHQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 899DB8017CC;
        Thu, 30 Jan 2020 00:16:38 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1ACA919756;
        Thu, 30 Jan 2020 00:16:35 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH libnftnl v4 0/3] Attributes for concatenated ranges
Date:   Thu, 30 Jan 2020 01:16:31 +0100
Message-Id: <cover.1580342940.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series adds support for NFTA_SET_DESC_CONCAT set attribute and
the additional key passed as NFTA_SET_ELEM_KEY_END to denote the
upper bound of a range in a generic way, as suggested by Pablo.

v4: Sync nf_tables.h header, move NFTNL_SET_DESC_CONCAT to avoid
    ABI breakage (Pablo Neira Ayuso)

v3: Support for separate "end" key added as 2/2, reworked 1/2 to
    use set description data for length of concatenation fields

Stefano Brivio (3):
  include: resync nf_tables.h cache copy
  set: Add support for NFTA_SET_DESC_CONCAT attributes
  set_elem: Introduce support for NFTNL_SET_ELEM_KEY_END

 include/libnftnl/set.h              |   2 +
 include/linux/netfilter/nf_tables.h |  17 +++++
 include/set.h                       |   2 +
 include/set_elem.h                  |   1 +
 src/set.c                           | 111 +++++++++++++++++++++++-----
 src/set_elem.c                      |  24 ++++++
 6 files changed, 138 insertions(+), 19 deletions(-)

--=20
2.24.1

