From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 4/4] netlink: fix linearize numgen type
Date: Thu, 27 Oct 2016 18:58:22 +0200
Message-ID: <20161027165822.GB17733@salvia>
References: <cover.1477170966.git.nevola@gmail.com>
 <901d89195567977f237e66ba75e4c7003e72164e.1477170966.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47100 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934935AbcJ0Q62 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 12:58:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CF65826E08
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:58:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEAE9DA81C
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:58:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4A0ADA847
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:58:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <901d89195567977f237e66ba75e4c7003e72164e.1477170966.git.nevola@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 22, 2016 at 11:36:47PM +0200, Laura Garcia Liebana wrote:
> Avoid to treat numgen type attribute as a register.

Also applied, thanks.
