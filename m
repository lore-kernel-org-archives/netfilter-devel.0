From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v4 0/3] Fix printing of range elements in named sets
Date: Wed, 19 Jul 2017 19:16:29 +0200
Message-ID: <20170719171629.GA18828@salvia>
References: <20170719130529.25398-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35836 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755241AbdGSRQl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2017 13:16:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 30B63523C2
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 19:16:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21567D1CA7
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 19:16:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B5F5DA7F4
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 19:16:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170719130529.25398-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 19, 2017 at 03:05:26PM +0200, Phil Sutter wrote:
> This is v4 of 'nft monitor' fixes for range elements. Apart from
> changing the new flag's location in struct expr as requested, this
> series now also covers mappings.

Series applied, thanks Phil!
