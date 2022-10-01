Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0ACC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Oct 2022 09:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiJAJnv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJAJn0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Oct 2022 05:43:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474E424F20
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Oct 2022 02:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0bi0plR0c3QqdW502SGOSbLkoiVoVGCFVuh3sgVhP7I=; b=g/ddKdnZQbYaMLqc6g6G594MnJ
        N72B2Rxe0MndnhN1JWSh+2kXnWn9UXOmXu/sf1xDqCMfADLkjActCD4iA8GJBWC8WsgGS3MQzMB7V
        4WvSgYBysFk7Dy+5BlV3Fwmm+VR+kciEXI3YxK2NhUlNWDKTHZ2mGFiRD8StX6hH8Qk5sJsf129Gm
        cn9EqpWALHvvLAURhkb860VDpiLninwbu2qDYCJ+vrcErXKmIj5zIq85qVYjR5iMsvDllP+0hGj0E
        opLTYl9+T6m+peSe3orwe4R/8UzhXWng4SFN+AyVtR2mpxjKhAa7f8Tra7m56X0NzNUVb+OS8JsIj
        9Abt9wSA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oeZ1o-0006RO-JJ
        for netfilter-devel@vger.kernel.org; Sat, 01 Oct 2022 11:43:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/4] tests: iptables-test: Test both variants by default
Date:   Sat,  1 Oct 2022 11:43:06 +0200
Message-Id: <20221001094310.29452-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

First three patches contain minor code refactoring for simplification.
Fourth patch changes default behaviour to run for both variants and
print a total summary, similar to shell testsuite.

Phil Sutter (4):
  tests: iptables-test: Simplify '-N' option a bit
  tests: iptables-test: Simplify execute_cmd() calling
  tests: iptables-test: Pass netns to execute_cmd()
  tests: iptables-test: Test both variants by default

 iptables-test.py | 135 ++++++++++++++++++++++++++---------------------
 1 file changed, 74 insertions(+), 61 deletions(-)

-- 
2.34.1

