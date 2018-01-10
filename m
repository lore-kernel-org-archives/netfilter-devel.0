From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables] extensions: add support for 'srh' match
Date: Wed, 10 Jan 2018 16:32:24 +0100
Message-ID: <20180110153224.3qtwicyu3sjzu2ec@salvia>
References: <1514545705-13868-1-git-send-email-amsalam20@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
To: Ahmed Abdelsalam <amsalam20@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59834 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754367AbeAJPc3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 10:32:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 901711F190A
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 16:32:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 813A0DA843
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 16:32:28 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1514545705-13868-1-git-send-email-amsalam20@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 29, 2017 at 12:08:25PM +0100, Ahmed Abdelsalam wrote:
> This patch adds a new exetension to iptables to supprt 'srh' match
> The implementation considers revision 7 of the SRH draft.
> https://tools.ietf.org/html/draft-ietf-6man-segment-routing-header-07
> 
> Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
> ---
>  extensions/libip6t_srh.c                | 283 ++++++++++++++++++++++++++++++++
>  include/linux/netfilter_ipv6/ip6t_srh.h |  63 +++++++

Please, add a extensions/libip6t_srh.t test file and send a v2.

Thanks.
