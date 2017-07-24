From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] monitor: Print NEWGEN events
Date: Mon, 24 Jul 2017 13:09:43 +0200
Message-ID: <20170724110943.GB6454@salvia>
References: <20170719143257.3772-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40858 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751539AbdGXLKD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 07:10:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4CBC8CA4AA
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 13:09:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13406DA81E
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 13:09:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03728D1CAA
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 13:09:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170719143257.3772-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 19, 2017 at 04:32:57PM +0200, Phil Sutter wrote:
> Now that they contain process information, they're actually interesting.
> For backwards compatibility, print process information only if it was
> present in the message.

Also applied, thanks.
