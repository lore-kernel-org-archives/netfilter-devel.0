From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables: Remove const qualifier from struct
 option.
Date: Thu, 21 Dec 2017 09:09:47 +0100
Message-ID: <20171221080947.4nv6q6jwlmw2e7oo@salvia>
References: <20171221033545.2676-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34506 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751130AbdLUIJx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Dec 2017 03:09:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9974FB6B84
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 09:09:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81BB31150A1
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 09:09:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171221033545.2676-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 21, 2017 at 09:05:44AM +0530, Varsha Rao wrote:
> As opts is reassigned multiple times, it cannot be made constant.
> So remove const qualifier from structure option. This patch fixes the
> following warning:
> 
> warning: initialization discards ‘const’ qualifier from pointer target
> type [-Wdiscarded-qualifiers]
>   .orig_opts = original_opts,

Applied, thanks Varsha.
