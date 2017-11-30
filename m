From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: xtables-eb: Remove const qualifier from struct
 option
Date: Thu, 30 Nov 2017 15:03:54 +0100
Message-ID: <20171130140354.GA6559@salvia>
References: <20171130134806.21737-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42984 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751456AbdK3OD7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 09:03:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C5BA303D02
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Nov 2017 15:03:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BF40DA863
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Nov 2017 15:03:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171130134806.21737-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 30, 2017 at 07:18:05PM +0530, Varsha Rao wrote:
> As opts is reassigned multiple times, it cannot be made constant.
> So remove const qualifier from structure option. This patch fixes the
> following warning.
> 
> xtables-eb.c: In function ‘ebt_load_match_extensions’:
> xtables-eb.c:653:7: warning: assignment discards ‘const’ qualifier
> from pointer target type
>   opts = ebt_original_options;

Applied, thanks Varsha.
