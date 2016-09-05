From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] conntrackd: cthelper: ftp: Set match offset/len for
 PORT mangling
Date: Mon, 5 Sep 2016 19:46:40 +0200
Message-ID: <20160905174640.GA29988@salvia>
References: <1472704075-38007-1-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ashley.hughes@blueyonder.co.uk, netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36980 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932810AbcIERqv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 13:46:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BCF88231668
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:46:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC593100794
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:46:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9031A9D6A4
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:46:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472704075-38007-1-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 31, 2016 at 09:27:53PM -0700, Kevin Cernekee wrote:
> Currently matchoff and matchlen are 0, so IP mangling is performed in
> the wrong place if NAT is used:
> 
>     FTP_NAT: type 0, off 0 len 0
> 
> The resultant packet is clearly incorrect:
> 
>     0x0000:  9410 3eb8 00ab 00e0 4c68 0012 0800 4510  ..>.....Lh....E.
>     0x0010:  0081 9ed9 4000 4006 cd35 646b 0370 646b  ....@.@..5dk.pdk
>     0x0020:  0212 0015 87c5 8cc2 de50 aa28 4842 8018  .........P.(HB..
>     0x0030:  00e3 459d 0000 0101 080a e916 985e 2a3b  ..E..........^*;
>     0x0040:  b82d 3530 3020 2731 3030 2c31 3037 2c32  .-500.'100,107,2
>     0x0050:  2c31 382c 3134 392c 3739 504f 5254 2031  ,18,149,79PORT.1
>     0x0060:  3932 2c31 3638 2c32 3534 2c32 2c31 3439  92,168,254,2,149
>     0x0070:  2c37 3927 3a20 636f 6d6d 616e 6420 6e6f  ,79':.command.no
>     0x0080:  7420 756e 6465 7273 746f 6f64 2e0d 0a    t.understood...
> 
> Add the missing assignments.

Applied, thanks.
