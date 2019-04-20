Return-Path: <SRS0=7w10=SW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFBBC282DD
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Apr 2019 17:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D241D20869
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Apr 2019 17:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfDTRQ4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Apr 2019 13:16:56 -0400
Received: from mail.thelounge.net ([91.118.73.15]:46343 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfDTRQ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Apr 2019 13:16:56 -0400
X-Greylist: delayed 1074 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Apr 2019 13:16:55 EDT
Received: from srv-rhsoft.rhsoft.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 44mfFH5qGzzXP0
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Apr 2019 18:58:59 +0200 (CEST)
To:     netfilter-devel@vger.kernel.org
From:   Reindl Harald <h.reindl@thelounge.net>
Subject: standalone fuzzing tool to debug net/netfilter
Openpgp: id=9D2B46CDBC140A36753AE4D733174D5A5892B7B8;
 url=https://arrakis-tls.thelounge.net/gpg/h.reindl_thelounge.net.pub.txt
Organization: the lounge interactive design
Message-ID: <901abbee-a077-365f-1fbc-b5681aec63a4@thelounge.net>
Date:   Sat, 20 Apr 2019 18:58:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: de-CH
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi

i suffer for a long time with unpredictable random crashes in production
which can be bridge/netfilter/network and since it takes up to weeks
sometimes for happen again unable to reprdocue it in a 1:1 testing
environment i would like to use some standalone tool "send shit" to the
nat/firewall/gateway device

goal: trigger such crashes outside production, catch debug infos with
kdump and/or serial console and write qualified bugreports

--------------------

the testing environment consists of 3 virtual machines within a nested
VMware ESXi:

* firewall vm reflect production with different ranges
* a mini VM connected to the LAN device with no physical
  backing listening on a complete /24 and a ton of
  socket-activated tcp/udp services
* a mini-vm connected to the wan interface of the gateway
  device to bypass the host networking and play "internet"

"mini" means really mini, so some c/c++ stuff compiled and statically
linked for the destination system leading to a simple command "do
whatever bad stuff to the network 172.17.0.0/24 until the kernel panics"
would be much appreciated

/dev/root            ext4            5.8G     66.2M      5.7G   1% /
/dev/sda1            ext4          189.9M      4.1M    185.8M   2% /boot
