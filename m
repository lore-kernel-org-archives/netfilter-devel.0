From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH ulogd2] ulogd: fix crash when ipv4 packet is truncated
Date: Mon, 17 Oct 2016 17:34:12 +0200
Message-ID: <20161017153412.GA9335@salvia>
References: <1476195747-2852-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>,
        Eric Leblond <eric@regit.org>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933956AbcJQPeW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 11:34:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 47461ED08D
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:34:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3020CBAC2D
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:34:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 371B2BAC43
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:34:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1476195747-2852-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 11, 2016 at 10:22:27PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> If ipv4 packet is truncated, we should not try to dereference the
> iph pointer. Otherwise, if the user add such iptables rules
> "-j NFLOG --nflog-size 0", we will dereference the NULL pointer
> and crash may happen.

With Eric's permission, I'm applying this. Thanks.
