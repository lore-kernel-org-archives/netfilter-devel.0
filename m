Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302F4C61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 17:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjBVRDF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 12:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBVRDE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 12:03:04 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C0D1CAD1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 09:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tZ7jTTKUW+vXdao317YzCVOS082ZYJVNgKZ9qNCN7YM=; b=dJ+5yYrtmdBCftldU+9mH5Ggle
        3Vr1mz0NuB9CODzWL+9bS+Ou1JwqaUFjMzCcAFYZzhJhpJifQD8lpNVwHSgc+qAvBVxwwgN4vdK4O
        lJj7Xv1dD4Y1kL8zkwzj1DdtCNQ7RYLmxLcMHvN9ZWoNCDhcjwbuYVlwWn7DXaILHnzw+ICWrw45Z
        eCw8MratFQsJ3CqyDP1dOMbC3ISHR5kXbGLrsDmWmFKR1qkhMr5e6pgYUPcviNQh7jVn+e2zZunzP
        Mn2bnedt9oOPbaxNHEi2VFYMqfLKca9loh3kz2VJHwTrEk/JXosJ20SwBiT9PZS4dajVd0j+LpgQa
        7fi7AbJA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pUsWC-0005Yx-FR; Wed, 22 Feb 2023 18:03:00 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [ipset PATCH 0/2] Two minor code fixes
Date:   Wed, 22 Feb 2023 18:02:39 +0100
Message-Id: <20230222170241.26208-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These were identified by Coverity tool, no problems in practice. Still
worth fixing to reduce noise in code checkers.

Phil Sutter (2):
  xlate: Fix for fd leak in error path
  xlate: Drop dead code

 lib/ipset.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

-- 
2.38.0

