From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: remove useless U8_MAX
 validation
Date: Mon, 31 Oct 2016 15:19:04 +0100
Message-ID: <20161031141904.GA21641@salvia>
References: <1477749387-13304-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52164 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934154AbcJaOTK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2016 10:19:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A91D8E8381
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:19:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 999B8DA848
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:19:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B1FDDA7FA
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:19:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477749387-13304-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 29, 2016 at 09:56:27PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> After call nft_data_init, size is already validated and desc.len will
> not exceed the sizeof(struct nft_data), i.e. 16 bytes. So it will never
> exceed U8_MAX.
> 
> Furthermore, in nft_immediate_init, we forget to call nft_data_uninit
> when desc.len exceeds U8_MAX, although this will not happen, but it's
> a logical mistake.
> 
> Now remove these redundant validation introduced by commit 36b701fae12a
> ("netfilter: nf_tables: validate maximum value of u32 netlink attributes")

Applied, thanks.
