Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59ADEB64DD
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jun 2023 06:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjF0Gxk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jun 2023 02:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjF0Gx2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2023 02:53:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9892D2136;
        Mon, 26 Jun 2023 23:53:09 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/6] Netfilter fixes for net
Date:   Tue, 27 Jun 2023 08:52:58 +0200
Message-Id: <20230627065304.66394-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Reset shift on Boyer-Moore string match for each block,
   from Jeremy Sowden.

2) Fix acccess to non-linear area in DCCP conntrack helper,
   from Florian Westphal.

3) Fix kernel-doc warnings, by Randy Dunlap.

4) Bail out if expires= does not show in SIP helper message,
   or make ct_sip_parse_numerical_param() tristate and report
   error if expires= cannot be parsed.

5) Unbind non-anonymous set in case rule construction fails.

6) Fix underflow in chain reference counter in case set element
   already exists or it cannot be created.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-06-27

Thanks.

----------------------------------------------------------------

The following changes since commit 6709d4b7bc2e079241fdef15d1160581c5261c10:

  net: nfc: Fix use-after-free caused by nfc_llcp_find_local (2023-06-26 10:57:23 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-06-27

for you to fetch changes up to b389139f12f287b8ed2e2628b72df89a081f0b59:

  netfilter: nf_tables: fix underflow in chain reference counter (2023-06-26 17:18:55 +0200)

----------------------------------------------------------------
netfilter pull request 23-06-27

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: conntrack: dccp: copy entire header to stack buffer, not just basic one

Ilia.Gavrilov (1):
      netfilter: nf_conntrack_sip: fix the ct_sip_parse_numerical_param() return value.

Jeremy Sowden (1):
      lib/ts_bm: reset initial match offset for every block of text

Pablo Neira Ayuso (2):
      netfilter: nf_tables: unbind non-anonymous set if rule construction fails
      netfilter: nf_tables: fix underflow in chain reference counter

Randy Dunlap (1):
      linux/netfilter.h: fix kernel-doc warnings

 include/linux/netfilter.h               |  4 +--
 lib/ts_bm.c                             |  4 ++-
 net/netfilter/nf_conntrack_proto_dccp.c | 52 +++++++++++++++++++++++++++++++--
 net/netfilter/nf_conntrack_sip.c        |  2 +-
 net/netfilter/nf_tables_api.c           |  6 +++-
 5 files changed, 60 insertions(+), 8 deletions(-)
