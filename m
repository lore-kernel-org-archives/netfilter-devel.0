From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: limit: use per-rule spinlock to
 improve the scalability
Date: Mon, 13 Mar 2017 19:32:02 +0100
Message-ID: <20170313183202.GA565@salvia>
References: <1489212489-30083-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49882 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753294AbdCMScL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 14:32:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D76041B8420
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 19:32:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C932CDA84A
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 19:32:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F812DA84B
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 19:32:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489212489-30083-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 11, 2017 at 02:08:09PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> The limit token is independent between each rules, so there's no
> need to use a global spinlock.

Applied, thanks.
