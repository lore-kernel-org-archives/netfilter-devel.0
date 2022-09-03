Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89031ECAAD5
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Sep 2022 10:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiICKRv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Sep 2022 06:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiICKRu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Sep 2022 06:17:50 -0400
X-Greylist: delayed 431 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 03 Sep 2022 03:17:49 PDT
Received: from mail1.systemli.org (mail1.systemli.org [93.190.126.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705FB5A3FF
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Sep 2022 03:17:49 -0700 (PDT)
Message-ID: <db95b6b2-ff01-c4ba-e3ea-8dd5f0fd8cf9@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1662199835;
        bh=mcwhuAxHFUaloaXKe1GiBQR4dPzXylFuNtYXhNANj9I=;
        h=Date:To:From:Subject:From;
        b=JJFP4BVZiA281dqi8FqQE3f9GINKyLbYwtY0JhXrT5QfjGPYrSwYFDiT/qzV1bdBt
         Kv10NqxUYzfiKWtk5Mco8VHiFhBT0lhPC3+K/WDiq5wYe73AFkiBd9jnaZSWlhIpBq
         KGYnfeM32IxQ6/VqAVLJu5TkUTI5BJ8Sp6a02I81B67zlu3mecrp4gVIOZmxrKb/KT
         u7gmTL5z6+C0xpioovCqcfpswcqXbh4lLJZgPlh4juLBF1z8k35l1MaGhaKjRli1ua
         2JLrTVEMiqisJj3L71F8QZAi86GTCd8zjaREUECAjTqS4QQe2cwAS3rGyOB9lDwii7
         6fFd2xTl4Ctdg==
Date:   Sat, 3 Sep 2022 12:10:34 +0200
MIME-Version: 1.0
Content-Language: en-US
To:     Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
From:   Nick <vincent@systemli.org>
Subject: CPE-ID?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,
I can not find any cpe-id for nftables? Typically, I query this 
database: https://nvd.nist.gov/vuln/search

Bests,
Nick

