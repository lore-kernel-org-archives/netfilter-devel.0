From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] xtables: fix build failure from COMPAT_XT_ALIGN
 outside CONFIG_COMPAT
Date: Thu, 18 May 2017 13:10:21 +0200
Message-ID: <20170518111021.GA3372@salvia>
References: <20170517152447.140777-1-willemdebruijn.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934131AbdERLKb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2017 07:10:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 09A3E1DF5B1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2017 13:10:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE295FF2C0
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2017 13:10:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5805FF2D2
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2017 13:10:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170517152447.140777-1-willemdebruijn.kernel@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 17, 2017 at 11:24:47AM -0400, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> The patch in the Fixes references COMPAT_XT_ALIGN in the definition
> of XT_DATA_TO_USER, outside an #ifdef CONFIG_COMPAT block.
> 
> Split XT_DATA_TO_USER into separate compat and non compat variants and
> define the first inside an CONFIG_COMPAT block.
> 
> This simplifies both variants by removing branches inside the macro.

Applied, thanks Willem.
