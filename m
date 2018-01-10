From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] parser_bison: delete chains via chain handle
Date: Wed, 10 Jan 2018 16:34:41 +0100
Message-ID: <20180110153441.sz5ad5yyyucwfv3n@salvia>
References: <cover.1515521149.git.harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60738 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932585AbeAJPet (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 10:34:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 15A811F1904
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 16:34:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 086ACDA854
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 16:34:48 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <cover.1515521149.git.harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 10, 2018 at 12:28:24AM +0530, Harsha Sharma wrote:
> Print chain handles with option '-a' and delete chains via chain handle

Harsha, could you send a follow up patch to add tests to tests/shell/
so we can automate that this works fine.

Thanks!
