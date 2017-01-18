From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: pkttype: unnecessary to check
 ipv6 multicast address
Date: Wed, 18 Jan 2017 20:33:34 +0100
Message-ID: <20170118193334.GA14270@salvia>
References: <1483796035-54792-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60210 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751025AbdARTfB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 14:35:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 932CC13C0CB
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 20:33:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81DC81B3018
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 20:33:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6351F1B3063
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 20:33:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1483796035-54792-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 07, 2017 at 09:33:54PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Since there's no broadcast address in IPV6, so in ipv6 family, the
> PACKET_LOOPBACK must be multicast packets, there's no need to check
> it again.

Applied, thanks Liping.
