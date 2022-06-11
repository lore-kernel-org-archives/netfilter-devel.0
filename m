Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51927C43334
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jun 2022 10:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiFKKIH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jun 2022 06:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiFKKIF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jun 2022 06:08:05 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABAFFC08
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jun 2022 03:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vwmBWFnTXo3AZ5j+8Bhcny2MacDuWeOw0cttPVib+XU=; b=nuluOrqJnipZIcB+iaD2SN7NXj
        H5paDb7NGU64ZWR/yz9inRd5pUZxC8qmLd/HrfHP4VuFRCnM2ZSvJt30FN1+xVyEPWGcn8Po1Z+zY
        A0wXgYC2Lw2A9TFABi1/F2Mnk0BJaDkrMh6NgLICJz9uX/aSL2Y4bnHuQl8qsZOj3y0qW8PRMTpdT
        5vM+GYUNM6VKlVas8SyWWoZlgx3WKr1bk0OlP6WNkC08hG0wkiA1OYD0lRrLAAyKg3y+1Zo4kwuMG
        kKaDk58yblgQQLwone3Jghze3A5tkxE3hZW0/Qe7wLzH2epfL5yT2AjFlRWsQYrzqn4pbxiSxfth+
        RhqIC19A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nzy2E-00061s-4G; Sat, 11 Jun 2022 12:08:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/2] Review xtables.h vs. xshared.h
Date:   Sat, 11 Jun 2022 12:07:40 +0200
Message-Id: <20220611100742.4888-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I didn't like how libxtables has to include xshared.h from iptables code
base, this series eliminates this:

* struct xtables_afinfo is used to hold family-specific configuration.
  There are static const instances in libxtables and
  xtables_set_nfproto() mangles the public 'afinfo' pointer. This is all
  libxtables code, so move the struct definition and pointer declaration
  into xtables.h (patch 1).

* XT_OPTION_OFFSET_SCALE is the base distance between different
  extensions' offset values. It is mostly used by libxtables when
  merging options and referenced by xshared.c for sanity checking only.
  Patch 2 moves it into xtables.h (and turns the single value enum into
  a define).

To avoid impact on external libxtables users, guard both changes above
by XTABLES_INTERNAL. Without access to xshared.h, external extensions
can't have made use of afinfo or XT_OPTION_OFFSET_SCALE yet.

Phil Sutter (2):
  libxtables: Move struct xtables_afinfo into xtables.h
  libxtables: Define XT_OPTION_OFFSET_SCALE in xtables.h

 extensions/libxt_set.c |  6 ++++++
 extensions/libxt_set.h |  1 -
 include/xtables.h      | 25 +++++++++++++++++++++++++
 iptables/xshared.h     | 26 --------------------------
 libxtables/xtables.c   |  1 -
 libxtables/xtoptions.c |  1 -
 6 files changed, 31 insertions(+), 29 deletions(-)

-- 
2.34.1

