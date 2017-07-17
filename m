From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: nf_ct_expect: fix expect removal
Date: Mon, 17 Jul 2017 17:17:45 +0200
Message-ID: <20170717151745.GA25741@salvia>
References: <20170717150648.10058-1-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58572 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751294AbdGQPRz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 11:17:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 177B6249D3
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:17:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07E5D1B3D58
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:17:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D368A1B3D54
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:17:38 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170717150648.10058-1-jslaby@suse.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jiri,

On Mon, Jul 17, 2017 at 05:06:48PM +0200, Jiri Slaby wrote:
> Commit ec0e3f01114a ("netfilter: nf_ct_expect: Add
> nf_ct_remove_expect()") introduced a helper nf_ct_remove_expect. It was
> used over the code, but one location used a wrong variable and it
> resulted in a crash in this call stack:
>   -> nf_ct_expect_related_report
>   -> nf_ct_remove_expect
>   -> del_timer
>   -> detach_if_pending
> 
> Switch to the proper variable.
> 
> Fixes: ec0e3f01114a
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

I have pushed out a similar fix from Florian:

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/?id=36ac344e16e04e3e55e8fed7446095a6458c64e6

Thanks for the fix anyway.
