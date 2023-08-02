Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D2BC0015E
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjHBCEY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjHBCEX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:04:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EBD212C
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=T4blAogervW9vczVa+/4GETelyACZm4HV6nWJTc1bBU=; b=LH2Qso2NFYlsiJbaO7EbN6NJAc
        0/C+oqw7z7aRaSjXLY4lRnZfEpnuLg8oIyiPHgPAZ9BVstrVUy15yE9XaNUFH/iZi0VG18Q/F/8ur
        r/3eFac1KbQ7AoXJAp4ZK+EB5RpIU+gZiZvHRKgRPM0AX1wMqJEjxY0P1Ccat8IYP/uJyxYfl59al
        +cnP78FqGt30xD1C7EKcGvv6eQxZX0YAXbs+yNNJvUzep0ewnC5aH7tkAwxRSZtAl/vZK9O39WFw9
        ArIuDH8hEZXHR7wDAQKTjSnPpkYquEavYOGpkME/1tz/TzvsV0pg3gT52U3fVw9tbL6/pu/E4MlnH
        Ps3sPiSA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1Dn-0002oZ-Bi; Wed, 02 Aug 2023 04:04:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Steven Barre <steven.barre@dxcas.com>
Subject: [iptables PATCH 01/16] man: iptables.8: Extend exit code description
Date:   Wed,  2 Aug 2023 04:03:45 +0200
Message-Id: <20230802020400.28220-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020400.28220-1-phil@nwl.cc>
References: <20230802020400.28220-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Codes 3 and 4 were missing.

Reported-by: Steven Barre <steven.barre@dxcas.com>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1353
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables.8.in | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index f81c632f2be86..2dd1406615106 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -410,9 +410,12 @@ the default setting.
 iptables can use extended packet matching and target modules.
 A list of these is available in the \fBiptables\-extensions\fP(8) manpage.
 .SH DIAGNOSTICS
-Various error messages are printed to standard error.  The exit code
-is 0 for correct functioning.  Errors which appear to be caused by
-invalid or abused command line parameters cause an exit code of 2, and
+Various error messages are printed to standard error.  The exit code is 0 for
+correct functioning.  Errors which appear to be caused by invalid or abused
+command line parameters cause an exit code of 2. Errors which indicate an
+incompatibility between kernel and user space cause an exit code of 3. Errors
+which indicate a resource problem, such as a busy lock, failing memory
+allocation or error messages from kernel cause an exit code of 4. Finally,
 other errors cause an exit code of 1.
 .SH BUGS
 Bugs?  What's this? ;-)
-- 
2.40.0

