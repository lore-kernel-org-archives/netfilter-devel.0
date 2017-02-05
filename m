From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] configure: Require newer version of libxtables
Date: Sun, 5 Feb 2017 21:48:39 +0100
Message-ID: <20170205204839.GA21340@salvia>
References: <20170202112255.GA18694@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44826 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751532AbdBEUss (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Feb 2017 15:48:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 08AD8131CAB
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:48:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EEC0BDA80C
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:48:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B357DA7F7
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:48:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170202112255.GA18694@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 02, 2017 at 09:22:55AM -0200, Elise Lennion wrote:
> Currently, the configure script requires xtables v1.6.0 when the option
> --with-xtables is given. However, nftables-0.7 build fails with this
> version, xtables v1.6.1 is the minimum required to have libxtables
> support.
> 
> Fixes(Bug 1110 - Build failure if --with-xtables).

Also applied, thanks Elise.
