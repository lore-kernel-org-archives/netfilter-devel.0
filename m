Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C76AC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244057AbiFHPhh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 11:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242253AbiFHPhg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 11:37:36 -0400
Received: from mail1.systemli.org (mail1.systemli.org [93.190.126.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F82919D605
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 08:37:35 -0700 (PDT)
Message-ID: <36adbaad-20aa-2909-6ec1-caf61b0364ad@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1654702651;
        bh=29C3tFecBp5eVUp1F9sDyFnuQAmQ1TkC53RUdDMxffk=;
        h=Date:To:From:Subject:From;
        b=r6l9nSClwaKsDzNOVMaARsOs8Egb54uUq9n/dOwxDZIocPTkIxJsWT+mfMP3vN9dh
         pa/UHsbinohZVOvN4Yo14e5d4QH8vq9waSNScaQYCOzpPFFbgs7EotDAEY6xFQ0TPa
         wC2Y21p6R3kXepbl+7u8e2pVp50ckLzWnJc/RnLJllPksyb65ZuXxVlrOcf50aFvSU
         C23kLNaOUpRbiqou0QvbfyU0eDieMSxv7DVZCBnT+Y4Vi3ioC5fzhI7fhmCPXuoCFo
         Qg3p8bKfKsPZa3QfOQ51iivkjD6qbRCubztWSs5ddZCmXNf5R1ZYlKe22EP3Pk/C8O
         YP7U+yfDjmqPg==
Date:   Wed, 8 Jun 2022 17:37:07 +0200
MIME-Version: 1.0
Content-Language: en-US
To:     Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
From:   Nick <vincent@systemli.org>
Subject: Add action to "finally" accept packets?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

OpenWrt switched to nftables in its firewall4 implementation [0]. Now 
people start porting their custom iptables rules to nft. However, there 
is a lack of "finally" accepting a packet without traversing the other 
chains with the same hook type and later priority in the same table 
[1,2]. Jumping/GoTo statements do not help [3]. Is it possible to add an 
action/policy allowing us to stop traversing the table?

[0] - https://git.openwrt.org/project/firewall4.git
[1] - https://github.com/openwrt/openwrt/issues/9981
[2] - https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains
[3] - https://wiki.nftables.org/wiki-nftables/index.php/Jumping_to_chain

