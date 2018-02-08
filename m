From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: linux-next: Signed-off-by missing for commit in the netfilter
 tree
Date: Thu, 8 Feb 2018 13:19:59 +0100
Message-ID: <20180208121959.2ob2vgbhhk55izib@salvia>
References: <20180208073301.209de5a0@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58190 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751562AbeBHMUK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Feb 2018 07:20:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF8721D94B3
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2018 13:20:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E24ADA78C
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2018 13:20:02 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180208073301.209de5a0@canb.auug.org.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Stephen,

On Thu, Feb 08, 2018 at 07:33:01AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Commit
> 
>   d8ed9600581d ("netfilter: remove useless prototype")
> 
> is missing a Signed-off-by from its committer.

That's my fault, sorry about that, it was unintentional.
