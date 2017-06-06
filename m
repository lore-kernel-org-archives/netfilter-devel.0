From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 3/4] conntrackd: cleanup if failed forking
Date: Tue, 6 Jun 2017 18:11:42 +0200
Message-ID: <20170606161142.GB15654@salvia>
References: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
 <149674671849.18546.543096306345523924.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37432 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbdFFQLu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 12:11:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1121D20990A
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:11:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05013100A7C
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:11:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04E4110078A
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:11:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149674671849.18546.543096306345523924.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 06, 2017 at 12:58:38PM +0200, Arturo Borrero Gonzalez wrote:
> Close the logs and lockfile if error while forking.

Also applied, thanks.
