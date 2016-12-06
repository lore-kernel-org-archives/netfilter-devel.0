From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: rpfilter: bypass ipv4 lbcast packets
 with zeronet source
Date: Tue, 6 Dec 2016 11:40:20 +0100
Message-ID: <20161206104020.GA5304@salvia>
References: <1480771508-4429-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47320 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752219AbcLFKkd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 05:40:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ADC06D1640
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:40:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1786DA3A0
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:40:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6A68DA38B
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:40:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1480771508-4429-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 03, 2016 at 09:25:08PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Otherwise, DHCP Discover packets(0.0.0.0->255.255.255.255) may be
> dropped incorrectly.

Applied, thanks Liping.
