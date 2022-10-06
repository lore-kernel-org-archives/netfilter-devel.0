Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFBD8C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiJFA3S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJFA3R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:29:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22976855AD
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HvvbqSi9uEjDCLGLa1yHljBsfCxymTjtyjAxM4Ufadw=; b=cjT5tQRXC+F+mXBNV+FIkXDVMY
        dVmJCVGQ+joxGclchB79TXVJNYVMok6620xOMUEpkGEv7tb6KOUjvqPs/pqu9RNGAQeFE2UVlkeia
        vFn9zd9MC4xE9gZoMbMDhqMiEcJo1ItUqOhWgDZLt5WnWLTo7IMSGHCqtn4P4oxrnf1VjO96+qT1H
        EkxDRui2xm+0ZF0LHjte0eFvma06uqyork+EP9lGW0zA+NM0rAlGtL3p44j/toqKR6Pp3dmaSHa1o
        zZ10Lrr3YVaT9RrMHGVpatCpqLRsgd6O2tuV/uiBacpbzCytRB/x63ItKFjTt9/8AxwPtLcOi+tF7
        SG8XmGGw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogElG-00020G-PR; Thu, 06 Oct 2022 02:29:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 09/12] tests: libebt_vlan.t: Drop trailing whitespace from rules
Date:   Thu,  6 Oct 2022 02:27:59 +0200
Message-Id: <20221006002802.4917-10-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221006002802.4917-1-phil@nwl.cc>
References: <20221006002802.4917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fast iptables-test.py mode is picky and it has to: Plain redirect target
prints a trailing whitespace, generally stripping the rules in test
cases won't work therefore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_vlan.t | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libebt_vlan.t b/extensions/libebt_vlan.t
index 81c795854fca0..3ec0559953331 100644
--- a/extensions/libebt_vlan.t
+++ b/extensions/libebt_vlan.t
@@ -4,8 +4,8 @@
 -p 802_1Q --vlan-prio 1;=;OK
 -p 802_1Q --vlan-prio ! 1;=;OK
 -p 802_1Q --vlan-encap ip;-p 802_1Q --vlan-encap 0800 -j CONTINUE;OK
--p 802_1Q --vlan-encap 0800 ;=;OK
--p 802_1Q --vlan-encap ! 0800 ;=;OK
+-p 802_1Q --vlan-encap 0800;=;OK
+-p 802_1Q --vlan-encap ! 0800;=;OK
 -p 802_1Q --vlan-encap IPv6 ! --vlan-id 1;-p 802_1Q --vlan-id ! 1 --vlan-encap 86DD -j CONTINUE;OK
 -p 802_1Q --vlan-id ! 1 --vlan-encap 86DD;=;OK
 --vlan-encap ip;=;FAIL
-- 
2.34.1

