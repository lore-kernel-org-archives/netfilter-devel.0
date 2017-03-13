From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: Parse ICMPv6 redirects
Date: Mon, 13 Mar 2017 13:40:50 +0100
Message-ID: <20170313124050.GA23998@salvia>
References: <1488880843-9352-1-git-send-email-alin.nastac@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alin Nastac <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44236 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750876AbdCMMlS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 08:41:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1FFC3BAC8C
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:41:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DAE74B8010
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:41:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A45CA7CD0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:40:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1488880843-9352-1-git-send-email-alin.nastac@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Alin,

On Tue, Mar 07, 2017 at 11:00:43AM +0100, Alin Nastac wrote:
> Extract IPv6 packet that triggered the sending of redirect message from
> ICMPv6 Redirected Header option and check if conntrack table contain such
> connection. Mark redirect packet as RELATED if a matching connection is found.

I think we need a sysctl to enable this on demand, eg.
'nf_conntrack_icmpv6_accept_redirects'

This is changing the default behaviour, my main concern here is that
filtering policies not accepting redirects will now make it via
RELATED.

I would prefer the user explicitly requests this.

Let me know, thanks!
