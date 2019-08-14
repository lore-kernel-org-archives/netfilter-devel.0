Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0436C32753
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 16:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FF932063F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 16:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfHNQxd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 12:53:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56128 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfHNQxd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 12:53:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::202])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1615154CD346;
        Wed, 14 Aug 2019 09:53:30 -0700 (PDT)
Date:   Wed, 14 Aug 2019 12:53:30 -0400 (EDT)
Message-Id: <20190814.125330.1934256694306164517.davem@davemloft.net>
To:     pablo@netfilter.org
CC:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: fallout from net-next netfilter changes
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 09:53:30 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


This started happening after Jakub's pull of your net-next changes
yesterday:

./include/uapi/linux/netfilter_ipv6/ip6t_LOG.h:5:2: warning: #warning "Please update iptables, this file will be removed soon!" [-Wcpp]
 #warning "Please update iptables, this file will be removed soon!"
  ^~~~~~~
In file included from <command-line>:
./include/uapi/linux/netfilter_ipv4/ipt_LOG.h:5:2: warning: #warning "Please update iptables, this file will be removed soon!" [-Wcpp]
 #warning "Please update iptables, this file will be removed soon!"
  ^~~~~~~

It's probaly from the standard kernel build UAPI header checks.

Please fix this.
