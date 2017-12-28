From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Thu, 28 Dec 2017 11:52:36 +0100
Message-ID: <20171228105236.hmii7xbk5jtctmpr@salvia>
References: <20171228072833.9980-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Duncan Roe <duncan_roe@optusnet.com.au>
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51696 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752905AbdL1Kwl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Dec 2017 05:52:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C8B94C5149
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 11:52:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0D3CFC5E5
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 11:52:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171228072833.9980-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc'ing Duncan.

On Thu, Dec 28, 2017 at 12:58:33PM +0530, Harsha Sharma wrote:
> Do not print timeout and burst in case default values are used.
> For e.g.
> iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
> --hashlimit-above 200/sec --hashlimit-mode srcip,dstport
> --hashlimit-name http1 -j DROP
> 
> nft add rule ip filter INPUT tcp dport 80 flow table http1 { tcp dport .
> ip saddr limit rate over 200/second } counter drop

This is what I was asking for.

Applied, thanks Harsha.

@Duncan: I think you can update the wiki again after this, given that
now those values should not be printed.
