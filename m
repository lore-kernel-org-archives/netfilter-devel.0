Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7492C43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC76120693
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfDZTZe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 15:25:34 -0400
Received: from mail.us.es ([193.147.175.20]:35684 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbfDZTZd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 15:25:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0934311ED85
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 21:25:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED22ADA70B
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 21:25:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E18C8DA707; Fri, 26 Apr 2019 21:25:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5344DA703;
        Fri, 26 Apr 2019 21:25:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 21:25:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C08D64265A31;
        Fri, 26 Apr 2019 21:25:29 +0200 (CEST)
Date:   Fri, 26 Apr 2019 21:25:29 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netfilter-devel@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter
 on flush
Message-ID: <20190426192529.yxzpunyenmk4yfk3@salvia>
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
 <09d0cd50-b64d-72c3-0aa1-82eb461bfa19@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <09d0cd50-b64d-72c3-0aa1-82eb461bfa19@6wind.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 25, 2019 at 05:41:45PM +0200, Nicolas Dichtel wrote:
> Le 25/04/2019 à 12:07, Nicolas Dichtel a écrit :
> [snip]
> > In fact, the conntrack tool set by default the family to AF_INET and forbid to
> > set the family to something else (the '-f' option is not allowed for the command
> > 'flush').
>
> 'conntrack -D -f ipv6' will do the job, but this is still a regression.

You mean, before this patch, flush was ignoring the family, and after
Kristian's patch, it forces you to use NFPROTO_UNSPEC to achieve the
same thing, right?
