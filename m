From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [net-next v2] netfilter: add segment routing header 'srh' match
Date: Mon, 8 Jan 2018 14:54:26 +0100
Message-ID: <20180108135426.tetjvke7jegawhiy@salvia>
References: <1515349322-23097-1-git-send-email-amsalam20@gmail.com>
 <20180108133711.dnxope5qjcnl3yvx@salvia>
 <145799DB-F1E3-4C70-B9BE-CE57E4F3F7E0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Ahmed AbdelSalam <amsalam20@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53946 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756990AbeAHNyb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 08:54:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CA948B6C7C
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 14:54:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA52953CDC
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 14:54:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <145799DB-F1E3-4C70-B9BE-CE57E4F3F7E0@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 08, 2018 at 02:45:16PM +0100, Ahmed AbdelSalam wrote:
> 
> > On 8 Jan 2018, at 14:37, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 
> > On Sun, Jan 07, 2018 at 07:22:02PM +0100, Ahmed Abdelsalam wrote:
> >> It allows matching packets based on Segment Routing Header
> >> (SRH) information.
> >> The implementation considers revision 7 of the SRH draft.
> >> https://tools.ietf.org/html/draft-ietf-6man-segment-routing-header-07
> >> 
> >> Currently supported match options include:
> >> (1) Next Header
> >> (2) Hdr Ext Len
> >> (3) Segments Left
> >> (4) Last Entry
> >> (5) Tag value of SRH
> > 
> > net/ipv6/netfilter/ip6t_srh.c: In function ‘srh_mt6’:
> > net/ipv6/netfilter/ip6t_srh.c:115:10: error: ‘struct ipv6_sr_hdr’ has
> > no member named ‘tag’
> >     !(srh->tag == srhinfo->tag)))
> >          ^
> > net/ipv6/netfilter/ip6t_srh.c:26:4: note: in definition of macro
> > ‘NF_SRH_INVF’
> >  ((boolean) ^ !!((ptr)->mt_invflags & (flag)))
> >    ^
> > 
> > Something breaks compilation here.
> 
> 
> This patch is based on David Miller net-next tree. 
> The reason for the compilation error is that you don’t have in your tree the following patch
> ipv6: sr: update the struct ipv6_sr_hdr (https://patchwork.ozlabs.org/patch/838198/ <https://patchwork.ozlabs.org/patch/838198/>). 
> In this patch the “tag” field was introduced to replace the reserved bits of SRH

OK. I'll included this in the next batch, once nf-next gets in sync
with net-next.

Thanks for explaining.
