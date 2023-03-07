Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518D4C678D4
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 13:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjCGN61 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 08:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCGN60 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 08:58:26 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6CD74DEC
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 05:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O3EcEz0UupV7//I4f2mtjn6eoX99ZePOdu4sc8BupEM=; b=FKcWSaviYDf4LwHYdZMm9Ml0ww
        szFA5FyltMhTA4r04faP69yBbecL7HfYCneeohNAowXk+aZgS+rdXHHTl3xT0HsJkoKbBIJ0n0GAa
        bJJRwagv6J6HX1PXZFYpCGA4RNhCXPGo8mcwFIkJMQFdxaDo1hMG4HdxfvBOoP8r0R7P92HbjtAgW
        tXwLrLGoY7dMMTq5fsm4kyJ3zDhiZxC208aCwz6Rd+oKM8/POYqCFMt6MV3YAx2HMRaNGcn3fFe2o
        g7FNbAOM+I6uJSJXi55jZXwHSczV14AEEypdJF1K3QHP5n6Sd/aUSH/Lt15XcrxhmGfEUFXzS3aK/
        LQwVo9pg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pZXpc-00058T-PJ; Tue, 07 Mar 2023 14:58:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ipset PATCH 4/4] tests: hash:ip,port.t: 'vrrp' is printed as 'carp'
Date:   Tue,  7 Mar 2023 14:58:12 +0100
Message-Id: <20230307135812.25993-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230307135812.25993-1-phil@nwl.cc>
References: <20230307135812.25993-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

| % grep vrrp /etc/protocols
| carp	112	CARP	vrrp		# Common Address Redundancy Protocol

Nowadays, carp seems to be the preferred name for protocol 112. Simply
change the expected output for lack of idea for a backwards compatible
change which is not simply using another protocol.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/hash:ip,port.t.list2 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/hash:ip,port.t.list2 b/tests/hash:ip,port.t.list2
index ffaedb561eb1c..0c5d3a15ef369 100644
--- a/tests/hash:ip,port.t.list2
+++ b/tests/hash:ip,port.t.list2
@@ -6,6 +6,6 @@ Size in memory: 480
 References: 0
 Number of entries: 3
 Members:
+2.0.0.1,carp:0
 2.0.0.1,tcp:80
 2.0.0.1,udp:80
-2.0.0.1,vrrp:0
-- 
2.38.0

