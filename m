Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC38BC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Mar 2022 17:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350859AbiCPRqE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 13:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344405AbiCPRqE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 13:46:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C422FFC5
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2022 10:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JKk480giI0nxASS4eF0WdxtAL5siSuxI4f88gukEIEo=; b=mbS4UF2JilNVnmpq+3BrAFAts3
        LES6LsE0u11iNS6cdjc/PlLPu37gj423hKBClu8vZOVUB0DGz4hbjRDcfDyZ95ijBEdlxcK2mK6K0
        xhVQUT/pUWsp+0ECuuRsrRTAafTomBI3EefCiPVOfua/VdXpabrlR48lzgm+BhnQQukXQFSRAvE+5
        szjeamJ4DYLn/EHEYq8+vehrPKhlbOaWsz3ML2IjI6WalfQJ9r1H0vhkX7PDYREnP51j6ZlmFuRcS
        Kew86gxiQOtmdswEqqtLJ5uHHJKDxJSNJfrKJcOYqpHsfmYRcez1wFzRif+3gFqKlKxCpBTmpMlae
        N7ioWaaA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nUXhW-0000OH-3m; Wed, 16 Mar 2022 18:44:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/3] Speed up restoring huge rulesets
Date:   Wed, 16 Mar 2022 18:44:40 +0100
Message-Id: <20220316174443.1930-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The largest penalty when restoring a large ruleset is checking for
whether a given target name is a chain or extension. Patch 2 adds a
cache to libxtables for failed extension lookups so consecutive ones
(e.g. multiple rules jumping to the same chain) are fast.

If a ruleset contains many user-defined chains, there is still a
significant slow-down due to the single extension lookup which remains.
Patch 3 introduces an announcement mechanism, implying that a chain line
in a dump file is never a target.

Testing my OCP ruleset (50k chains, 130k rules, 90k chain jumps) again:

variant		before		after
-------------------------------------
legacy		1m31s		2.6s
nft		1m47s		13s

The performance gain is large enough to justify the lost warning if a
chain name clashes with a non-standard target. The only case which was
forbidden before, namely a clash with standard target (DROP, ACCEPT,
etc.) is still caught due to patch 1 of this series.

Changes since RFC:
- Introduce patch 1 to catch the only real issue
- Slight performance drop with nft due to the kept standard target check
- Update commit messages

Phil Sutter (3):
  nft: Reject standard targets as chain names when restoring
  libxtables: Implement notargets hash table
  libxtables: Boost rule target checks by announcing chain names

 include/xtables.h           |  3 ++
 iptables/iptables-restore.c |  1 +
 iptables/xshared.c          |  4 +-
 iptables/xshared.h          |  2 +-
 iptables/xtables-restore.c  |  6 +--
 libxtables/xtables.c        | 81 +++++++++++++++++++++++++++++++++++++
 6 files changed, 90 insertions(+), 7 deletions(-)

-- 
2.34.1

