From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 4/4 v2] doc/manual/conntrack-tools:
 include some bits about init systems
Date: Mon, 5 Sep 2016 14:22:00 +0200
Message-ID: <20160905122200.GD13834@salvia>
References: <147305973403.17904.10544144874704834411.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35602 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754545AbcIEMWK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 08:22:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF597A7E32
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 14:22:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E2F6114D73
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 14:22:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56B07114D7A
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 14:22:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <147305973403.17904.10544144874704834411.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 05, 2016 at 09:16:45AM +0200, Arturo Borrero Gonzalez wrote:
> Update the conntrack-tools manual to include some bits regarding init systems
> and the integration with systemd.
> 
> More on this topic here:
>  http://ral-arturo.blogspot.com.es/2016/08/why-conntrackd-in-debian-is-better-with.html
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v2: include suggestions reported by Rami Rosen.

Applied, thanks.

Rami, thanks a lot for reviewing this too.
