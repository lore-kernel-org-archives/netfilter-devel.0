Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA70C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 13:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhLHNzJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 08:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbhLHNzJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 08:55:09 -0500
Received: from dehost.average.org (dehost.average.org [IPv6:2a01:4f8:130:53eb::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5259C061746
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Dec 2021 05:51:37 -0800 (PST)
Received: from [IPV6:2a02:8106:1:6800:8b1c:cff2:1ce3:e09b] (unknown [IPv6:2a02:8106:1:6800:8b1c:cff2:1ce3:e09b])
        by dehost.average.org (Postfix) with ESMTPSA id CAC84394DEC7
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Dec 2021 14:51:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1638971495; bh=jWVkmMPUX6dHtp8N6fyZWocpFiXYhV8KfKlNoexddxc=;
        h=Date:From:Subject:To:From;
        b=UGg4LvDPQsy4ATnbJfZbPTO3pg2xEhsMNDBkZ8MVBUEOAmcPFLzZS1zBoagRsSgXH
         JfavAh9JOmS5JQF65zHYzVH9KZhNKwc1BJQHUjE6t4iqBkMEkyGh7VACdsR1jTrqby
         vunI7abe0EsxegRmip5p4IwJJCGYHtODa8J30leg=
Message-ID: <843b84ac-f59e-c1d9-46c3-84133c3ab9a4@average.org>
Date:   Wed, 8 Dec 2021 14:51:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
From:   Eugene Crosser <crosser@average.org>
Subject: [PATCH nft] Improve handling of errors from mnl* functions"
To:     netfilter-devel@vger.kernel.org
Content-Language: en-GB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
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
