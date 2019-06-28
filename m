Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10073C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 17:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E760C2086D
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 17:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfF1Raa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 13:30:30 -0400
Received: from mail.us.es ([193.147.175.20]:49304 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfF1Raa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 13:30:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A500B19D8AC
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 19:30:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 960521021A7
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 19:30:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 86F42DA7B6; Fri, 28 Jun 2019 19:30:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 684BFA5B8;
        Fri, 28 Jun 2019 19:30:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Jun 2019 19:30:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.195.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 282454265A2F;
        Fri, 28 Jun 2019 19:30:24 +0200 (CEST)
Date:   Fri, 28 Jun 2019 19:30:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     zhe.he@windriver.com
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Fix remainder of pseudo-header protocol 0
Message-ID: <20190628173023.f45mvwcdhnavnt42@salvia>
References: <1561346258-272481-1-git-send-email-zhe.he@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1561346258-272481-1-git-send-email-zhe.he@windriver.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 24, 2019 at 11:17:38AM +0800, zhe.he@windriver.com wrote:
> From: He Zhe <zhe.he@windriver.com>
> 
> Since v5.1-rc1, some types of packets do not get unreachable reply with the
> following iptables setting. Fox example,
> 
> $ iptables -A INPUT -p icmp --icmp-type 8 -j REJECT
> $ ping 127.0.0.1 -c 1
> PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
> — 127.0.0.1 ping statistics —
> 1 packets transmitted, 0 received, 100% packet loss, time 0ms
> 
> We should have got the following reply from command line, but we did not.
> From 127.0.0.1 icmp_seq=1 Destination Port Unreachable
> 
> Yi Zhao reported it and narrowed it down to:
> 7fc38225363d ("netfilter: reject: skip csum verification for protocols that don't support it"),
> 
> This is because nf_ip_checksum still expects pseudo-header protocol type 0 for
> packets that are of neither TCP or UDP, and thus ICMP packets are mistakenly
> treated as TCP/UDP.
> 
> This patch corrects the conditions in nf_ip_checksum and all other places that
> still call it with protocol 0.

Applied, thanks.
