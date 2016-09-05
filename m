From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables_trace: fix endiness when dump
 chain policy
Date: Mon, 5 Sep 2016 19:29:15 +0200
Message-ID: <20160905172915.GA9225@salvia>
References: <1472820552-7803-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32874 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936570AbcIER3Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 13:29:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3D6CA231664
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:29:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2BAD9CE14C
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:29:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A77D114D6C
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:29:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472820552-7803-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 02, 2016 at 08:49:12PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> NFTA_TRACE_POLICY attribute is big endian, but we forget to call
> htonl to convert it. Fortunately, this attribute is parsed as big
> endian in libnftnl.

Applied, thanks!
