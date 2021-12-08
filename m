Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E7BC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 13:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhLHNxN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 08:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbhLHNxN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 08:53:13 -0500
X-Greylist: delayed 161467 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Dec 2021 05:49:41 PST
Received: from dehost.average.org (dehost.average.org [IPv6:2a01:4f8:130:53eb::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECA3C061746
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Dec 2021 05:49:41 -0800 (PST)
Received: from wncross.fkb.profitbricks.net (unknown [IPv6:2a02:8106:1:6800:8b1c:cff2:1ce3:e09b])
        by dehost.average.org (Postfix) with ESMTPA id E0709394DE98
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Dec 2021 14:49:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1638971378; bh=sI9bBkpdRwAyxVzGYSmaNFUcTH1xJR5BFeMIFMQ+Kt4=;
        h=From:To:Subject:Date:From;
        b=o05AEMXYprZ74MAyJkvcQW4qyD87vwzGHFFhm0usdPtIxw/8hXbrQ9Fh411YDVpo2
         l84DTA8rrTp/3BTbbTJlEt/9mcpgVCXQ0dXMPwTE5T+prZzVfMjZJpUhCPSQ5TIIRO
         +jlJGXc+K3bp/2fdXwCqTd5PTBTpS0TlKq4p6O7E=
From:   Eugene Crosser <crosser@average.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] Improve handling of errors from mnl* functions"
Date:   Wed,  8 Dec 2021 14:49:12 +0100
Message-Id: <20211208134914.16365-1-crosser@average.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Libnftables does not handle errors that libmnl functions may return
properly:

1. Retriable errors indicated by errno=EINTR are not retried, but
   rather treted as fatal.
2. Instead of reporting the error to the caller, functions call
   exit() on error, which terminates the caller process.

This patch set partly addresses the second point, by calling
abort() instead of exit() on ABI error, that will at least give
more information to the sysadmin than quiet termination of a
process.

It attempts to properly address the first point, by introducing
retry logic when mnl_socket_recvfrom() or mnl_cb_run() return
-1 with errno=EINTR.

It would be desirable to fully address the second point at some
future time, though it requires some redesign of the code structure.

 [PATCH nft 1/2] Use abort() in case of netlink_abi_error
 [PATCH nft 2/2] Handle retriable errors from mnl functions

