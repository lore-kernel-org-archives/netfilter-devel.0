Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E984CC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 18:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238039AbhLIS34 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:29:56 -0500
Received: from dehost.average.org ([88.198.2.197]:49804 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhLIS34 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 13:29:56 -0500
Received: from wncross.lan (unknown [IPv6:2a02:8106:1:6800:300b:b575:41c4:b71a])
        by dehost.average.org (Postfix) with ESMTPA id E6F38394FB1B
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Dec 2021 19:26:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1639074381; bh=Y1QYsGzrEJ9JEaI+/AH5oFCEC/On2PsosBmn+rqJwyo=;
        h=From:To:Subject:Date:From;
        b=MRSYFp05Q1JlOPwv4hNb8UqbjbgCNDpB1GRdxTwsmdKSch1HkkioRxmOr9FCgoNmz
         1nEpcpCOunJMLAEaeknVf9AVgADwDWZKWjjcHqVbwIMSmRaZ9WqH8etdI069BsV1Or
         PttmxVZ8TnvV6UflrJ7Xl+DKpfYJtbnN95l5bDOI=
From:   Eugene Crosser <crosser@average.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft v2 0/2] Improve handling of errors from mnl* functions"
Date:   Thu,  9 Dec 2021 19:26:05 +0100
Message-Id: <20211209182607.18550-1-crosser@average.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

   Version 2 of the patchset

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

  [PATCH nft v2 1/2] Use abort() in case of netlink_abi_error
  [PATCH nft v2 2/2] Handle retriable errors from mnl functions

