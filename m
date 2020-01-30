Return-Path: <SRS0=SOhW=3T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E83C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DED91206A2
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:17:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="clhuwWL+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgA3ARI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 19:17:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22094 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726760AbgA3ARI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 19:17:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580343427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R9v9B8k0dKY7R3zvDrNEDvhF8Nm6H0h9xd7Gg0c3zzw=;
        b=clhuwWL+lFnt5z1FLKz472A+o6popCjxKybyLJJmEWuw0XI5l0o3Ww4d6N7q683vbsYtvl
        uC4Wgs1uoWenzEPK0QE/zwyubTSflQT63oop+uy0EjE86HU4FfqkIyxA3VzUbjkhOS+mUY
        OHdQ5bnwAFHBvLVsyoxTQu250efEeaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-mXgzBLfoPDSHQ1nZRwv14w-1; Wed, 29 Jan 2020 19:17:03 -0500
X-MC-Unique: mXgzBLfoPDSHQ1nZRwv14w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8365F107ACC7;
        Thu, 30 Jan 2020 00:17:02 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AD59166A9;
        Thu, 30 Jan 2020 00:17:00 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v4 0/4] Introduce support for concatenated ranges
Date:   Thu, 30 Jan 2020 01:16:54 +0100
Message-Id: <cover.1580342294.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is the counterpart of kernel series:
  nftables: Set implementation for arbitrary concatenation of ranges

Patch 1/4 updates the nf_tables.h UAPI header from the kernel, as it
includes changes needed in the subsequent patches.

Patch 2/4 adds support for the NFTA_SET_DESC_CONCAT netlink
attributes: they specify the length of fields within concatenations,
and they are needed by set implementations in the kernel to figure
out where single fields start and stop.

Patch 3/4 introduces new key data semantics needed to represent
arbitrary concatenation of ranges, as well as required changes in
lexer and expression evaluation. Closing element of concatenated
ranges is now expressed by a separate key, as proposed by Pablo.

Patch 4/4 adds test cases for operations on the new set type.

v4: Patch 1/4 added, no further changes
v3: Changes listed in messages for all patches
v2: Changes listed in messages for 2/3 and 3/3

Stefano Brivio (4):
  include: resync nf_tables.h cache copy
  src: Add support for NFTNL_SET_DESC_CONCAT
  src: Add support for concatenated set ranges
  tests: Introduce test for set with concatenated ranges

 include/expression.h                          |   3 +
 include/linux/netfilter/nf_tables.h           |  17 ++
 include/rule.h                                |  11 +-
 src/evaluate.c                                |  19 +-
 src/mnl.c                                     |   7 +
 src/netlink.c                                 | 120 ++++++++++---
 src/parser_bison.y                            |  17 +-
 src/rule.c                                    |  15 +-
 src/segtree.c                                 | 117 +++++++++++++
 .../testcases/sets/0042concatenated_ranges_0  | 162 ++++++++++++++++++
 10 files changed, 445 insertions(+), 43 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0042concatenated_ranges_0

--=20
2.24.1

