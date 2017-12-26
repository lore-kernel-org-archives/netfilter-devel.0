From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix potential NULL-ptr deref in
 nf_tables_dump_obj_done()
Date: Tue, 26 Dec 2017 17:16:32 +0100
Message-ID: <20171226161632.crbztezivhkw4ku2@salvia>
References: <1514172894-8477-1-git-send-email-liuhangbin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
To: Hangbin Liu <liuhangbin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48984 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbdLZQQh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Dec 2017 11:16:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7737526E20
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Dec 2017 17:16:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6849FFAB41
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Dec 2017 17:16:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1514172894-8477-1-git-send-email-liuhangbin@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 25, 2017 at 11:34:54AM +0800, Hangbin Liu wrote:
> If there is no NFTA_OBJ_TABLE and NFTA_OBJ_TYPE, the c.data will be NULL in
> nf_tables_getobj(). So before free filter->table in nf_tables_dump_obj_done(),
> we need to check if filter is NULL first.

Applied, thanks!
