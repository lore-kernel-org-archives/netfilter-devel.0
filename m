From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] systemd: fix missing log.h include
Date: Sun, 4 Dec 2016 21:34:08 +0100
Message-ID: <20161204203408.GA12811@salvia>
References: <148067457876.19755.4897734997943160784.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36422 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbcLDUeS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 15:34:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 73AB0A7E22
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:34:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65E6DDA861
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:34:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6F682DA85F
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:34:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <148067457876.19755.4897734997943160784.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 02, 2016 at 11:29:38AM +0100, Arturo Borrero Gonzalez wrote:
> Produces this:
>  warning: implicit declaration of function 'dlog'

Applied, thanks Arturo.
