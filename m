From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: nf_tables: add fib expression to
 the netdev family
Date: Mon, 31 Jul 2017 19:02:54 +0200
Message-ID: <20170731170254.GB4218@salvia>
References: <20170720235438.18576-1-pablombg@gmail.com>
 <20170720235438.18576-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50212 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750967AbdGaRDC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 13:03:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E90FF2EFEA4
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:02:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA21EDA80E
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:02:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0742DA80E
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:02:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170720235438.18576-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 21, 2017 at 01:54:38AM +0200, Pablo M. Bermudo Garay wrote:
> Add fib expression support for netdev family. Like inet family, netdev
> delegates the actual decision to the corresponding backend, either ipv4
> or ipv6.
> 
> This allows to perform very early reverse path filtering, among other
> things.

Also applied, thanks!
