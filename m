From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nfnetlink_log: add "nf-logger-5-1"
 module alias name
Date: Sun, 4 Dec 2016 20:44:15 +0100
Message-ID: <20161204194415.GB3516@salvia>
References: <1479134468-18999-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56058 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbcLDTo2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 14:44:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E0B8211E588
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 20:44:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0C06DA843
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 20:44:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D97D1DA848
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 20:44:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1479134468-18999-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 14, 2016 at 10:41:08PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> So we can autoload nfnetlink_log.ko when the user adding nft log
> group X rule in netdev family.

Also applied, thanks!
