From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: extensions: don't add nat by
 default
Date: Mon, 24 Apr 2017 10:39:13 +0200
Message-ID: <20170424083913.GC3408@salvia>
References: <20170420081135.20812-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52750 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1166981AbdDXIjW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Apr 2017 04:39:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 35FF2523C1
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:39:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24A01A742
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:39:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9ECCFF2D9
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:39:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170420081135.20812-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 20, 2017 at 10:11:32AM +0200, Florian Westphal wrote:
> The nat extension only holds information needed by pptp and the masquerade target (and
> in the latter case its not essential), so no need to attach it by default.
> 
> First two patches add the nat extension in masquerade and pptp case, 3rd patch
> gets rid of the default-add.
> 
> This saves 8 bytes in the extension blob unless a connection
> is subject to MASQERUADE and/or pptp nat helper.

Series applied, thanks Florian.
