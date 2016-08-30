From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables_netdev: remove redundant ip_hdr
 assignment
Date: Tue, 30 Aug 2016 11:41:48 +0200
Message-ID: <20160830094148.GA18901@salvia>
References: <1472374792-22765-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58238 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753548AbcH3JmB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 05:42:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F151011E580
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:41:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1C18FB45C
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:41:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07DC5100A77
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:41:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472374792-22765-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 28, 2016 at 04:59:52PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> We have already use skb_header_pointer to get the ip header pointer,
> so there's no need to use ip_hdr again. Moreover, in NETDEV INGRESS
> hook, ip header maybe not linear, so use ip_hdr is not appropriate,
> remove it.

Applied, thanks!
