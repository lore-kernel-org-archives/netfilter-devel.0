Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1C4C6FA8B
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Sep 2022 16:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiIUQxD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 12:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbiIUQwk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 12:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CECDF93;
        Wed, 21 Sep 2022 09:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E51A6321C;
        Wed, 21 Sep 2022 16:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5333AC433D6;
        Wed, 21 Sep 2022 16:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663778939;
        bh=81mWQ998LxO0FArc0H1G2FjJmMbDnM+S1neGgiGa8v8=;
        h=From:To:Cc:Subject:Date:From;
        b=NZPmZ11RyAThZrXkuPV5BeojdSXkS22RcgRE1PxvFFkAB2vuUBq7mEZNtOto+9hGA
         6SQCNuIPN+iYv54QH8zXA+/ROupA1gnHO1SZ3TYJ4g5x22uYR3+AU7EpaIFyHmGdf8
         9xJpbIXb/cvE3MeY9gt80/d60qJ0gEuo6u1BEtOJ0KF1RPBLTZao2JUOOH1ePFHoD1
         UAG7TS0IwRBpbMarfq50vtxk3qKiiDFXLPru28Iv88WC4coyw4CXAGaFADhKRO2QUY
         lkdoGRZ4yA84mrfegVxAqlzZjbN6yZfqQfb0BS0WPlswipiC7ggCRw+K9caYBJtgK3
         Ml5RD+mUBiS3A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH v3 bpf-next 0/3] Introduce bpf_ct_set_nat_info kfunc helper
Date:   Wed, 21 Sep 2022 18:48:24 +0200
Message-Id: <cover.1663778601.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
destination nat addresses/ports in a new allocated ct entry not inserted
in the connection tracking table yet.
Introduce support for per-parameter trusted args.

Changes since v2:
- use int instead of a pointer for port in bpf_ct_set_nat_info signature
- modify KF_TRUSTED_ARGS definition in order to referenced pointer constraint
  just for PTR_TO_BTF_ID
- drop patch 2/4

Changes since v1:
- enable CONFIG_NF_NAT in tools/testing/selftests/bpf/config

Kumar Kartikeya Dwivedi (1):
  bpf: Tweak definition of KF_TRUSTED_ARGS

Lorenzo Bianconi (2):
  net: netfilter: add bpf_ct_set_nat_info kfunc helper
  selftests/bpf: add tests for bpf_ct_set_nat_info kfunc

 Documentation/bpf/kfuncs.rst                  | 24 ++++++----
 kernel/bpf/btf.c                              | 18 +++++--
 net/netfilter/nf_conntrack_bpf.c              | 47 ++++++++++++++++++-
 tools/testing/selftests/bpf/config            |  1 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c | 10 ++--
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 27 +++++++++++
 6 files changed, 110 insertions(+), 17 deletions(-)

-- 
2.37.3

