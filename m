From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_queue][PATCH 2/2] Declare the define visivility
 attribute together
Date: Fri, 14 Apr 2017 01:49:11 +0200
Message-ID: <20170413234911.GA9656@salvia>
References: <20170410195804.18238-1-raj.khem@gmail.com>
 <20170410195804.18238-2-raj.khem@gmail.com>
 <20170413233719.GB8577@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Khem Raj <raj.khem@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59100 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753288AbdDMXt3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:49:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 901A1C1241
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:49:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE015DA729
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:49:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F2E1DA7F7
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:49:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170413233719.GB8577@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 14, 2017 at 01:37:19AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 10, 2017 at 12:58:04PM -0700, Khem Raj wrote:
> > clang ignores the visibility attribute if its not
> > defined before the definition. As a result these
> > symbols become hidden and consumers of this library
> > fail to link due to these missing symbols
> 
> Also applied, thanks.

Argh. Now we have two different ways to do this accross different
libraries.

Moreover, in you patch:

http://patchwork.ozlabs.org/patch/749223/

+int __EXPORTED nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
                         const void *data, uint32_t data_len)

for what it used to be:

+int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
                         const void *data, uint32_t data_len)

I wonder if there is a way to do this without a follow up patch to fix
all these indentations.

If this is just to fix clang, can you probably follow this patch instead?

http://git.netfilter.org/libmnl/commit/?id=dcdb47373a375087d2dd8cee5e2a9c66fcc147eb

It would be good if you send me a patch for libnetfilter_queue that
applies on top of you previous patch, or I can simply revert.

I just would like to keep this consistent for all libraries while
fixing this clang issue.
