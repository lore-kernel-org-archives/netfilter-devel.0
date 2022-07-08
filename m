Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE9CC43334
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Jul 2022 18:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239612AbiGHS2z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239619AbiGHS2i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 14:28:38 -0400
X-Greylist: delayed 568 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 08 Jul 2022 11:27:57 PDT
Received: from srv-olb.onlyservers.dedyn.io (srv-olb.onlyservers.dedyn.io [51.195.40.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ED984EF5
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2022 11:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=at.encryp.ch;
        s=encrypch-ovh; t=1657304306;
        bh=AetNkD5asBcWrlPcymRqhfuE3VD5NKEE7iITbJSENXY=;
        h=Date:To:From:Subject;
        b=BXBFK4nqiaqMllMbC3CnhYqLHyrz/ymX0Uj3ujHOHWeDNctuPz1Qb/lS80Q0gApM4
         6Z8/MSSd+jDXGrjTNqRIFtTMFcNfXl52SBzMqDsMoRZDMP0uTtUz15nK1OoF+HyhGH
         w9YN4mL9HfGL5oc6zVdkAb+oQ5yujH8MopU0Wwqw=
Message-ID: <fef69c25-3b17-a111-f447-744d3afe750b@at.encryp.ch>
Date:   Fri, 8 Jul 2022 21:18:24 +0300
MIME-Version: 1.0
To:     netfilter-devel@vger.kernel.org
Content-Language: en-US
From:   Serg <jpo39rxtfl@at.encryp.ch>
Subject: libnftnl broken examples
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I am trying to integrate my userspace tool with nftables directly, i.e. 
without executing nft utility.

However, I failed to find any libnftnl-related documentation, so I tried 
to play with examples located at 
<https://git.netfilter.org/libnftnl/tree/examples>. I tried to run 
nft-set-elem-add.c, but every time I got `error: Invalid argument'. 
Could you help me troubleshoot this issue, please?

Some details about my system to help reproduce this issue:

0. Clone master branch from git.netfilter.org

1. nftables rules are:

# nft add table ip table_example
# nft 'add set ip table_example set_example { type ipv4_addr; }'

2. My linux kernel version is 5.15.32

3. Run the following command:

$ sudo ./nft-set-elem-add ip table_example set_example

Thank you!

