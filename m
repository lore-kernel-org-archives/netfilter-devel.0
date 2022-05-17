Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA326C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 08:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239517AbiEQIL6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 04:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242674AbiEQILC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 04:11:02 -0400
Received: from smtp-bc0e.mail.infomaniak.ch (smtp-bc0e.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc0e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F542DDA
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 01:10:57 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L2TMf4BykzMpnlD;
        Tue, 17 May 2022 10:10:54 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4L2TMf0v4LzlhRV4;
        Tue, 17 May 2022 10:10:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652775054;
        bh=QSvIKgcPbtswa6FCH51xSiVof77XHJ5FF/xz//8wBlY=;
        h=Date:From:To:Cc:References:Subject:In-Reply-To:From;
        b=INqGamUJNKXAS6+uYsxv1scucimt4LtXYvj6t9q454KX9iYsfxX4UO7SkNQq1sN0s
         hDpjGIHRYVSC9Yq23XzK9eAuljA0ti4CVPXIim2Tf+GQTrtj7R9QtXkiNQjp6C3tHY
         nxyhyD5dVZD4Gr2IgnT4JtmpaQegMuIrm3zuLrmI=
Message-ID: <ed56f8a3-5469-2b62-ea29-1f7164b0638a@digikod.net>
Date:   Tue, 17 May 2022 10:10:53 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-6-konstantin.meskhidze@huawei.com>
 <9456ccf3-e2b3-bb65-f24f-e6d2761120e5@digikod.net>
Subject: Re: [PATCH v5 05/15] landlock: landlock_add_rule syscall refactoring
In-Reply-To: <9456ccf3-e2b3-bb65-f24f-e6d2761120e5@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 17/05/2022 10:04, Mickaël Salaün wrote:
> You can rename the subject to "landlock: Refactor landlock_add_rule()"
> 
> 
> On 16/05/2022 17:20, Konstantin Meskhidze wrote:

[...]

>> helper was added to support current filesystem rules. It is called
>> by the switch case.
> 
> You can rephrase (all commit messages) in the present form:
present *tense*
> 
> Refactor the landlock_add_rule() syscall to easily support for a new 
> rule type in a following commit. The new add_rule_path_beneath() helper 
> supports current filesystem rules.
