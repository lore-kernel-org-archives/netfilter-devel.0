From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] parser_bison: delete chains via chain handle
Date: Wed, 10 Jan 2018 16:35:16 +0100
Message-ID: <20180110153516.bgh676z5jblrjow2@salvia>
References: <cover.1515521149.git.harshasharmaiitr@gmail.com>
 <20180110153441.sz5ad5yyyucwfv3n@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32770 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934206AbeAJPfU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 10:35:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8D2EE1F1900
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 16:35:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80403DA84D
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 16:35:19 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180110153441.sz5ad5yyyucwfv3n@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 10, 2018 at 04:34:41PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 10, 2018 at 12:28:24AM +0530, Harsha Sharma wrote:
> > Print chain handles with option '-a' and delete chains via chain handle
> 
> Harsha, could you send a follow up patch to add tests to tests/shell/
> so we can automate that this works fine.

Same thing applies to every new handle deletion that you add in your
patches.
