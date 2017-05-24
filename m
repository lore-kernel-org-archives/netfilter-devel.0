From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] extensions: libxt_cluster: Add translation to nft
Date: Wed, 24 May 2017 17:44:19 +0200
Message-ID: <20170524154419.GA24697@salvia>
References: <1495629111-8206-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo@debian.org, fw@strlen.de
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58952 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932956AbdEXPo2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 11:44:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D5ACFDFE28
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 17:44:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C32F21007AC
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 17:44:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC70DFF2D1
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 17:44:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1495629111-8206-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 24, 2017 at 06:01:51PM +0530, Shyam Saini wrote:
> Add translation for cluster to nft

I think this should be:

        -m cluster --cluster-total-nodes 2 --cluster-local-node 1 --cluster-hash-seed 0xdeadbeef

should be translated to:

        jhash ct original saddr mod 2 seed 0xdeadbeef eq 0

if --cluster-local-node is 2, then:

        jhash ct original saddr mod 2 seed 0xdeadbeef eq 1
