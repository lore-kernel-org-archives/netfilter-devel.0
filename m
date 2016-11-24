From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_range: add the missing NULL pointer
 check
Date: Thu, 24 Nov 2016 13:48:31 +0100
Message-ID: <20161124124831.GA22736@salvia>
References: <1479734303-20832-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56118 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936137AbcKXMsk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 07:48:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B081520942A
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:48:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1BB2A7D45
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:48:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89EDEA7D44
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:48:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1479734303-20832-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 21, 2016 at 09:18:23PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Otherwise, kernel panic will happen if the user does not specify
> the related attributes.

Applied, thanks!
