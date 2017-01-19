From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: remove GC_MAX_EVICTS break
Date: Thu, 19 Jan 2017 14:27:26 +0100
Message-ID: <20170119132726.GA3138@salvia>
References: <1484587496-24177-1-git-send-email-fw@strlen.de>
 <a1041af4-85ca-33da-cc4b-5eea3de3d882@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33292 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752560AbdASN1e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Jan 2017 08:27:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 07AD8FB44C
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 14:27:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC3F38E638
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 14:27:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66E708E63A
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 14:27:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <a1041af4-85ca-33da-cc4b-5eea3de3d882@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 17, 2017 at 10:10:23AM +0100, Nicolas Dichtel wrote:
> Le 16/01/2017 à 18:24, Florian Westphal a écrit :
> > Instead of breaking loop and instant resched, don't bother checking
> > this in first place (the loop calls cond_resched for every bucket anyway).
> > 
> > Suggested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied, thanks!
