From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 nft 2/4] src: add offset attribute for hash expression
Date: Wed, 9 Nov 2016 00:22:51 +0100
Message-ID: <20161108232251.GB32040@salvia>
References: <20161104130109.GA20452@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33988 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750832AbcKHXWz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 18:22:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4B1EC8D0502
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:22:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39EC7DA7F6
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:22:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 38047DA80C
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:22:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161104130109.GA20452@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 04, 2016 at 02:01:12PM +0100, Laura Garcia Liebana wrote:
> Add support to add an offset to the hash generator, eg.
> 
>  ct mark set hash ip saddr mod 10 offset 100
> 
> This will generate marks with series between 100-109.

Also applied, thanks.
