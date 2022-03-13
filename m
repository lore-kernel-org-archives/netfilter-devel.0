Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889EBC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 13 Mar 2022 09:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbiCMJZD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Mar 2022 05:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiCMJZD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Mar 2022 05:25:03 -0400
X-Greylist: delayed 463 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 13 Mar 2022 01:23:55 PST
Received: from nodachi.mjopr.nl (nodachi.mjopr.nl [31.210.16.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BBA10216E
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Mar 2022 01:23:55 -0800 (PST)
Received: from [192.168.2.164] (unknown [143.176.158.61])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sander)
        by nodachi.mjopr.nl (Postfix) with ESMTPSA id E6CF71FF5C
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Mar 2022 10:16:10 +0100 (CET)
Message-ID: <b054d06e-4d79-27d9-cbeb-5c9822453ba7@users.sourceforge.net>
Date:   Sun, 13 Mar 2022 10:16:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     netfilter-devel@vger.kernel.org
From:   Pander <pander@users.sourceforge.net>
Subject: Xtables-addons URL issues
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all, ej,

Here are some URL issues for xtables-addons. Page 
https://inai.de/projects/xtables-addons/geoip.php

1) Has link 
https://build.opensuse.org/package/files?package=xtables-geoip&project=security%3Anetfilter 
which is broken, please fix if possible.

2) Link http://marc.info/?l=netfilter&m=130375362317626&w=2 redirects to 
https://marc.info/?l=netfilter&m=130375362317626&w=2 so better use that 
link as  it is HTTPS.

3) Link https://inai.de/about redirects to https://inai.de/about/ which 
is a minor fix. This is in the footer and applies to all pages for this 
website.

4) Link http://people.netfilter.org/acidfu/geoip/howto/ redirects to 
https://people.netfilter.org/acidfu/geoip/howto/ so also better to use.

See also 
https://validator.w3.org/checklink?uri=https%3A%2F%2Finai.de%2Fprojects%2Fxtables-addons%2Fgeoip.php

Thanks,

Pander

