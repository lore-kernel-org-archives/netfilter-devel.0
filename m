From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_conntrack: make nf_conntrack_max
 as an unsigned int knob
Date: Fri, 14 Apr 2017 00:06:50 +0200
Message-ID: <20170413220650.GA4445@salvia>
References: <1491643945-8557-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46846 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755271AbdDMWHS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 18:07:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 28FB9BA705
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:07:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 67489DA863
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:07:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4EF61DA793
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:07:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491643945-8557-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 08, 2017 at 05:32:25PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> It doesn't work when we set a large value to the nf_conntrack_max, as
> well as the nf_conntrack_expect_max:
>   # echo 4294967295 > /proc/sys/net/nf_conntrack_max
>   bash: echo: write error: Invalid argument
> 
> So convert to use proc_douintvec.

Why do you want such an large amount of entries?

I'm not applying this.
