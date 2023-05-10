Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BCAC77B7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 May 2023 16:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjEJQPy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 May 2023 12:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjEJQPZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2023 12:15:25 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13187ABF
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2023 09:15:20 -0700 (PDT)
Date:   Wed, 10 May 2023 16:14:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1683735317; x=1683994517;
        bh=pSLaPRG119Zjlc00d6madstQ6YOF1X5bxvNlgAjUduw=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=SSefuh0GzGafZ2WRmenX+x8h/zqKjWnTxtBo4r6/p07ylflTStCmUo/hgjt9jcaux
         8mA5Bov15hEVl5G5iaVSSGsS+yfbgEiYLrRJmVrqEfGec+ALxrQgBErNCeiFxdf29M
         8deTsPhb0ZTCeW/0rjzepSJjJut9G0vZ2Qt7PXRThmXQgLGdL9MAt7uDxuv9C9pQIM
         S2SKqu3M9x2CE+zQOhwVDYtnbUmO/1MKYAxBx/GcyxYg+kIqlk9dxFC4YQsZ1LIEfC
         CD70px6ePpyeF/WyieLxdIVZA8uXlwMd8hW2LLhnp9+y6Jw7kWU3K0CNUH2K6v7ktp
         4Psik6QoRA97A==
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From:   Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc:     "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
Subject: New Linux kernel NetFilter flaw gives attackers root privileges
Message-ID: <LSClKXeU0dZe8AaW7hr07tgKs3K_rte4VTbyw-3WKVu6f5XE1SCWqTPX75RlFMLHmAeic91tvkaXp0hKcmcE_-tAkmAaiAmUmSfibJzsq9k=@protonmail.com>
Feedback-ID: 39510961:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Subject: New Linux kernel NetFilter flaw gives attackers root privileges

Good day from Singapore,

I have just come across this article. Thought of sharing it.

Article: New Linux kernel NetFilter flaw gives attackers root privileges
Link: https://www.bleepingcomputer.com/news/security/new-linux-kernel-netfi=
lter-flaw-gives-attackers-root-privileges/

Thank you.

Regards,

Mr. Turritopsis Dohrnii Teo En Ming
Targeted Individual in Singapore
Blogs:
https://tdtemcerts.blogspot.com
https://tdtemcerts.wordpress.com
GIMP also stands for Government-Induced Medical Problems.




Sent with Proton Mail secure email.
