From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ebt: Use ebt_invalid_target instead
 of INVALID_TARGET
Date: Wed, 31 May 2017 09:57:13 +0200
Message-ID: <20170531075713.GA1240@salvia>
References: <1496194092-92995-1-git-send-email-gfree.wind@vip.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: gfree.wind@vip.163.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751028AbdEaH5T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 May 2017 03:57:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F9D4E1233
        for <netfilter-devel@vger.kernel.org>; Wed, 31 May 2017 09:57:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01634100A7C
        for <netfilter-devel@vger.kernel.org>; Wed, 31 May 2017 09:57:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C5E1100790
        for <netfilter-devel@vger.kernel.org>; Wed, 31 May 2017 09:57:08 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1496194092-92995-1-git-send-email-gfree.wind@vip.163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 31, 2017 at 09:28:12AM +0800, gfree.wind@vip.163.com wrote:
> From: Gao Feng <gfree.wind@vip.163.com>
> 
> Use the new helper function ebt_invalid_target instead of the old
> macro INVALID_TARGET to enhance the readability.

ebt_mark and _snat can use this too. They seem to be opencoding this
function.
