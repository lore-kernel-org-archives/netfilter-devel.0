From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v2] libxt_sctp: fix array out of range in
 print_chunk
Date: Mon, 13 Nov 2017 14:29:03 +0100
Message-ID: <20171113132903.GA25437@salvia>
References: <20171113123854.GA7570@salvia>
 <20171113132754.14911-1-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        huaibin Wang <huaibin.wang@6wind.com>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42400 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751842AbdKMN3T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 08:29:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B04E68D050A
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 14:29:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A15FEDA840
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 14:29:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171113132754.14911-1-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 13, 2017 at 02:27:54PM +0100, Nicolas Dichtel wrote:
> From: huaibin Wang <huaibin.wang@6wind.com>
> 
> For chunk type ASCONF, ASCONF_ACK and FORWARD_TSN, sctp_chunk_names[].chunk_type
> is not equal to the corresponding index in sctp_chunk_names[]. Using this field
> leads to a segmentation fault (index out of range).
> 
> Example
> $ iptables -A INPUT -p sctp --chunk-type all ASCONF,ASCONF_ACK,FORWARD_TSN -j ACCEPT
> $ iptables -L
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> Segmentation fault

Applied, thanks a lot Nicolas.
