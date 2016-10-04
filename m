From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 1/2] libxt_hashlimit: Prepare libxt_hashlimit.c for
 revision 2
Date: Tue, 4 Oct 2016 08:57:33 +0200
Message-ID: <20161004065733.GA13023@salvia>
References: <20160926190817.GA10252@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu, johunt@akamai.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, pai.vishwain@gmail.com
To: Vishwanath Pai <vpai@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34528 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752472AbcJDG5q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Oct 2016 02:57:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A471A9D355
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 08:57:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9748CB7FF1
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 08:57:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97AB6B7FF2
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 08:57:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160926190817.GA10252@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 26, 2016 at 03:08:17PM -0400, Vishwanath Pai wrote:
> I am planning to add a revision 2 for the hashlimit xtables module to
> support higher packets per second rates. This patch renames all the
> functions and variables related to revision 1 by adding _v1 at the
> end of the names.

Applied, thanks.
