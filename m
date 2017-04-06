From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/1] netfilter: ctlink: Return error directly
 when create expect without help
Date: Fri, 7 Apr 2017 00:44:25 +0200
Message-ID: <20170406224425.GA2340@salvia>
References: <1490665972-10967-1-git-send-email-gfree.wind@foxmail.com>
 <20170406195529.GA6653@salvia>
 <001801d2af23$cf669b50$6e33d1f0$@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, 'Gao Feng' <fgao@ikuai8.com>
To: Gao Feng <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38360 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751593AbdDFWog (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 18:44:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 615F5137B85
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:44:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 516ECDA7E9
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:44:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C5E3DA807
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:44:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <001801d2af23$cf669b50$6e33d1f0$@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 07, 2017 at 06:19:07AM +0800, Gao Feng wrote:
> Yes, it is better.
> Would you apply this patch which you attached directly, or need I send
> another v2 update?

I'll apply this one. No need to send v2.
