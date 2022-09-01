Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4B0ECAAD1
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Sep 2022 16:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbiIAQoC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 12:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbiIAQnz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 12:43:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4849F96FC2;
        Thu,  1 Sep 2022 09:43:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3ED6B82897;
        Thu,  1 Sep 2022 16:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EB3C433D6;
        Thu,  1 Sep 2022 16:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662050631;
        bh=Qds5SzB7QlcyjlI7GbDlm3LKqMs+QHqG2ogYXBX+RpM=;
        h=From:To:Cc:Subject:Date:From;
        b=q+7GW71X09m5ZIQX94gBBv/ZSDUpCNEUqV3UN6NajLtqDGQpIqJ1bjoEe9D4Y9rTz
         pyYdWar5tbQT62TWmqtWMJkizQ+t7QnN/OMj/KAnuCXAQM+vEaNF5HA1K0BbYzkzcH
         GmhjOE5kBo0qcMT4Jg+lg8cmilJjGnatDfKPvqghKPKMKsGBcavAp4PpXTZ/Sy2cmj
         EvGKVaUDVUmHLWX6osd6vKJjYdn1xW7NRh5fv1WgIalnhXQaQsF7Z9R904/qg/n30Y
         aiYP2wZq6iFehYZ0Qhgiq2FS3Nmxoc0d+XwsPSo1O7moIdHbWxYjGnusklTJmP+JMv
         uaL3+mQZMMl4g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH bpf-next 0/4] Introduce bpf_ct_set_nat_info kfunc helper
Date:   Thu,  1 Sep 2022 18:43:23 +0200
Message-Id: <cover.1662050126.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
destination nat addresses/ports in a new allocated ct entry not inserted
in the connection tracking table yet.
Introduce support for per-parameter trusted args.

Kumar Kartikeya Dwivedi (2):
  bpf: Add support for per-parameter trusted args
  selftests/bpf: Extend KF_TRUSTED_ARGS test for __ref annotation

Lorenzo Bianconi (2):
  net: netfilter: add bpf_ct_set_nat_info kfunc helper
  selftests/bpf: add tests for bpf_ct_set_nat_info kfunc

 Documentation/bpf/kfuncs.rst                  | 18 +++++++
 kernel/bpf/btf.c                              | 39 ++++++++++-----
 net/bpf/test_run.c                            |  9 +++-
 net/netfilter/nf_conntrack_bpf.c              | 49 ++++++++++++++++++-
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  2 +
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 26 +++++++++-
 tools/testing/selftests/bpf/verifier/calls.c  | 38 +++++++++++---
 7 files changed, 156 insertions(+), 25 deletions(-)

-- 
2.37.2

