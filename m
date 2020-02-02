Return-Path: <SRS0=01nl=3W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812ACC3524A
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Feb 2020 14:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A77A20643
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Feb 2020 14:14:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=tootai.net header.i=@tootai.net header.b="ogM+kSG3";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=tootai.net header.i=@tootai.net header.b="Me5CXHEU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgBBOOQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Feb 2020 09:14:16 -0500
Received: from mail1.tootai.net ([213.239.227.108]:49430 "EHLO
        mail1.tootai.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgBBOOQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Feb 2020 09:14:16 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Feb 2020 09:14:15 EST
Received: from mail1.tootai.net (localhost [127.0.0.1])
        by mail1.tootai.net (Postfix) with ESMTP id 179F16081368
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Feb 2020 15:08:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=tootai.net; s=mail;
        t=1580652493; bh=I4ocqrrbnxFgQeD5fRVFjHvAeKNOXGfUZXI/TpLZftU=;
        h=To:From:Subject:Date:From;
        b=ogM+kSG3xnLnv+6Wj78vuGGxYdLa0CSe6BxATmIl/bVI8UvGl0A21LPoMTTLvBfRx
         /5Yp4z1pXLVbh1XFj9om1Svm7QiJt2TcTMWiiltMpyPzbK4r625R5FzgdE49pCcBb6
         ykVr8OvYiJJcav+Ez5q3RcRdMA8KJKvw9GDG0b7E=
Received: from [192.168.10.24] (unknown [192.168.10.24])
        by mail1.tootai.net (Postfix) with ESMTPSA id CCD1F6081367
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Feb 2020 15:08:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=tootai.net; s=mail;
        t=1580652492; bh=I4ocqrrbnxFgQeD5fRVFjHvAeKNOXGfUZXI/TpLZftU=;
        h=To:From:Subject:Date:From;
        b=Me5CXHEU8wK9yDDZ6qYNMjPGSH7Ar+yZViTnJjyGmPwo35Dau3PoEPoM8n6Pr0Dw0
         citONPkFe4s9nt21PL6IJ0NLcqwWbXiohR+WB7kaK1tfyBWi7bHbs54DrTBWlqkluK
         khVu2b9ACzbsS9ooGRV8ToGiZJrO2U4JiaHfetZE=
To:     Netfilter list <netfilter-devel@vger.kernel.org>
From:   Daniel <tech@tootai.net>
Subject: NFT - delete rules per interface
Message-ID: <1292e1cd-d593-b1a5-2850-3ae18bd54a6c@tootai.net>
Date:   Sun, 2 Feb 2020 15:06:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: fr-FR
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

is there an easy way to delete rules/set/maps/... for a specific interface ?

Regards

-- 
Daniel
