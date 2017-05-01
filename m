From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_ct_ext: invoke destroy even when
 ext is not attached
Date: Mon, 1 May 2017 11:49:13 +0200
Message-ID: <20170501094913.GA4015@salvia>
References: <1493474389-9217-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S642868AbdEAJtS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 05:49:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3800F1F4B86
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 11:49:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A72DFF14F
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 11:49:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14742DA870
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 11:49:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1493474389-9217-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 29, 2017 at 09:59:49PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> For NF_NAT_MANIP_SRC, we will insert the ct to the nat_bysource_table,
> then remove it from the nat_bysource_table via nat_extend->destroy.
> 
> But now, the nat extension is attached on demand, so if the nat extension
> is not attached, we will not be notified when the ct is destroyed, i.e.
> we may fail to remove ct from the nat_bysource_table.
> 
> So just keep it simple, even if the extension is not attached, we will
> still invoke the related ext->destroy. And this will also preserve the
> flexibility for the future extension.

Applied, thanks.
