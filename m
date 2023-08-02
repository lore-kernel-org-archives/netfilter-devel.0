Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D21CEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjHBCEz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjHBCEx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:04:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B926212D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oUwssCubsHestsANx8KnTNqbOoOnZZAFrDw9JPDo5FE=; b=ate9UMz0ZdzevSL8vIuMJ5rzX6
        JFgqy7m+SPHNWHN4qEbE2b25EVeM82RBtCEQlAZtqXmewcZ4Kh2xuAfNk7B90WWP3G8aykYGv49Ey
        B5MTgW2845DBcZyTckWEAkjVlOK68TtvXfdVK2DYqxkuNtozhtS1mdcZssi5bBA6bqBDoKd88xBhV
        5XBIYxtjxdEj/dNmvl5TeUGi/vIvJO1WKb2CSU8ciFTrCLsq5tJ5bzbxaYvlhgec2MEpzItOkG4t6
        qtn+AmespDH7GFOrZa7diLN2rRZcYnhlxyD00eow8Mj3qa3sKuWi4IY3bJlWXPrXXp3EFvE9+Mr1M
        mgaT2f1g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1EJ-0002qs-EO; Wed, 02 Aug 2023 04:04:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     debian@helgefjell.de
Subject: [iptables PATCH 15/16] man: iptables-save.8: Start paragraphs in upper-case
Date:   Wed,  2 Aug 2023 04:03:59 +0200
Message-Id: <20230802020400.28220-16-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020400.28220-1-phil@nwl.cc>
References: <20230802020400.28220-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also add a missing full stop.

Reported-by: debian@helgefjell.de
Fixes: 117341ada43dd ("Added iptbles-restore and iptables-save manpages")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-save.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index c0d9b202ad7bd..540f85d485ee2 100644
--- a/iptables/iptables-save.8.in
+++ b/iptables/iptables-save.8.in
@@ -46,10 +46,10 @@ Specify a filename to log the output to. If not specified, iptables-save
 will log to STDOUT.
 .TP
 \fB\-c\fR, \fB\-\-counters\fR
-include the current values of all packet and byte counters in the output
+Include the current values of all packet and byte counters in the output.
 .TP
 \fB\-t\fR, \fB\-\-table\fR \fItablename\fP
-restrict output to only one table. If the kernel is configured with automatic
+Restrict output to only one table. If the kernel is configured with automatic
 module loading, an attempt will be made to load the appropriate module for
 that table if it is not already there.
 .br
-- 
2.40.0

