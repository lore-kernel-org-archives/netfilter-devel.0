From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v5 0/5] netfilter: exit_net checks for objects
 initialized in net_init hook
Date: Sun, 12 Nov 2017 12:44:57 +0100
Message-ID: <20171112114457.GM5512@breakpoint.cc>
References: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
 <2f512ef8-8bb8-c227-1cde-1be56ae4c3ec@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, coreteam@netfilter.org
To: Vasily Averin <vvs@virtuozzo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43320 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751101AbdKLLpk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2017 06:45:40 -0500
Content-Disposition: inline
In-Reply-To: <2f512ef8-8bb8-c227-1cde-1be56ae4c3ec@virtuozzo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vasily Averin <vvs@virtuozzo.com> wrote:
> OpenVz kernel team have a long history of fighting against namespace-related bugs,
> some of them could be excluded by using simple checks described below.
> 
> One of typical errors is related to live cycle of namespaces:
> usually objects created for some namespace should not live longer than namespace itself.

These changes look good to me, thank you.
