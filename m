From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_cthelper] examples: kill the "invalid
 argument" error in nftc-helper-add
Date: Wed, 22 Mar 2017 14:09:53 +0100
Message-ID: <20170322130953.GA21858@salvia>
References: <1490187647-61659-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48776 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751698AbdCVNKG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 09:10:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 513A91395D5
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 14:10:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 42912DA875
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 14:10:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0125DA879
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 14:09:56 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1490187647-61659-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 22, 2017 at 09:00:47PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> NFCTH_PRIV_DATA_LEN is a must attribute required by the kernel when
> creating the cthelper, add it now. Otherwise -EINVAL will be returned.

Applied, thanks Liping.
