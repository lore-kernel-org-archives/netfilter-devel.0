From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/2] src: add new generic context structure nft_ctx
Date: Mon, 26 Jun 2017 19:00:17 +0200
Message-ID: <20170626170017.GA9650@salvia>
References: <20170623163825.2066-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34062 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751101AbdFZRAX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 13:00:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 69B3BE0420
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:00:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 578621B4042
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:00:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74A641B4042
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:00:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170623163825.2066-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 23, 2017 at 06:38:24PM +0200, Pablo M. Bermudo Garay wrote:
> The new structure nft_ctx is meant to be used as a generic container of
> context information.
> 
> This is a preparatory patch. So at the moment the struct just carry
> output_ctx on his path through main.c and cli.c.

Applied, thanks!
