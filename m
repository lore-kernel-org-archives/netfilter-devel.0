From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 1/4] src/main: refresh help message
Date: Mon, 5 Sep 2016 14:21:14 +0200
Message-ID: <20160905122114.GA13834@salvia>
References: <147255963490.17411.649527820452381341.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35222 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755217AbcIEMVe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 08:21:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 21719A7E33
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 14:21:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13F20114D6B
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 14:21:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 159CF32CD
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 14:21:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <147255963490.17411.649527820452381341.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 30, 2016 at 02:20:35PM +0200, Arturo Borrero Gonzalez wrote:
> It seems there are two kind of options:
>  * general commands (-d, -v, -h, -C)
>  * client commands (which requires another conntrackd instance)
> 
> Refresh the help message to better reflect this.

Applied, thanks.
