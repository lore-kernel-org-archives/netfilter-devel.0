From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Iptables PATCH] extensions: Add test for cluster nft translation
Date: Fri, 19 Jan 2018 13:15:38 +0100
Message-ID: <20180119121538.ijhrowhgtngb26b7@salvia>
References: <1516119613-9709-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751200AbeASMPn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 07:15:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2F0711C4368
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:15:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D3A2DA390
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:15:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1516119613-9709-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 16, 2018 at 09:50:13PM +0530, Shyam Saini wrote:
> This patch adds test cases for iptables to nft translation of cluster match
> This adds all test cases including corner cases.
> 
> Run these test cases like:
> 
> 	$ ./xlate-test.py extensions/libxt_cluster.txlate

Applied, thanks Shyam.
