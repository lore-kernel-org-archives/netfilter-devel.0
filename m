From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] parser_bison: Allow flushing maps
Date: Mon, 20 Mar 2017 11:15:40 +0100
Message-ID: <20170320101540.GB10209@salvia>
References: <20170317150406.GA1298@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33664 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753322AbdCTKXn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 06:23:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5BD4C2493E
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:15:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48575DA807
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:15:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15D2BDA875
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:15:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170317150406.GA1298@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 17, 2017 at 12:04:06PM -0300, Elise Lennion wrote:
> This patch enables the command flush on maps, which removes all
> entries in it:
> 
> $ nft flush map filter map1
> 
> Command above flushes map 'map1' in table 'filter'.
> 
> The documentation was updated accordingly.

Also applied, thanks.
