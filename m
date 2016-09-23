From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] libnftnl: remove libmxml support
Date: Fri, 23 Sep 2016 11:23:49 +0200
Message-ID: <20160923092349.GA15412@salvia>
References: <147455629375.27979.9866845521114348969.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43732 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757892AbcIWJYC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Sep 2016 05:24:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5280112A684
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2016 11:23:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 413F8DA847
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2016 11:23:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D68FDA84D
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2016 11:23:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <147455629375.27979.9866845521114348969.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 22, 2016 at 04:58:13PM +0200, Arturo Borrero Gonzalez wrote:
> This patch removes the libmxml integration in libnftnl, since we have
> JSON in place and there is no need to support two at the same time.
> 
> The JSON support is much better, for example libjansson has a better
> parsing error reporting.
> 
> Moreover, libmxml 2.10 breaks the integration with libnftnl somehow,
> as reported in Debian bug #83870 [0].
> 
> Also, the XML support inside libnftnl has never been in good shape, with
> several tiny inconsitencies.

Applied, thanks Arturo.
