From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink_linearize: exthdr op must be u32
Date: Mon, 11 Dec 2017 13:47:29 +0100
Message-ID: <20171211124729.GB1550@salvia>
References: <20171211091933.28916-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35770 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752681AbdLKMrl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Dec 2017 07:47:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 46AE869267
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Dec 2017 13:47:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37BB4DA7F7
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Dec 2017 13:47:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171211091933.28916-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 11, 2017 at 10:19:33AM +0100, Florian Westphal wrote:
> libnftnl casts this to u32. Broke exthdr expressions on bigendian.

Applied, thanks.
