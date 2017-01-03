From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: nft_ct: add average bytes per
 packet support
Date: Tue, 3 Jan 2017 14:41:58 +0100
Message-ID: <20170103134158.GB30663@salvia>
References: <1482667139-63731-1-git-send-email-zlpnobody@163.com>
 <1482667139-63731-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35542 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759029AbdACNmG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Jan 2017 08:42:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3A5F5523C1
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Jan 2017 14:42:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B2F39D693
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Jan 2017 14:42:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FDAC9D699
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Jan 2017 14:42:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1482667139-63731-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 25, 2016 at 07:58:59PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Similar to xt_connbytes, user can match how many average bytes per packet
> a connection has transferred so far.

Also applied, thanks.
