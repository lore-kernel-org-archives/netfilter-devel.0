From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2] netfilter: Remove duplicated rcu_read_lock.
Date: Mon, 19 Jun 2017 20:20:52 +0200
Message-ID: <20170619182052.GA19682@salvia>
References: <20170605152125.24978-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ja@ssi.bg, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51606 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbdFSSU5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2017 14:20:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 23EB52EFEA7
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 20:20:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12B07D191C
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 20:20:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 175D971F9
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 20:20:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170605152125.24978-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 06, 2017 at 12:21:25AM +0900, Taehee Yoo wrote:
> Some functions are called by nf_hook() and these
> functions hold rcu_read_lock() But nf_hook() already holds
> rcu_read_lock() therefore callee's rcu_read_lock() are useless.
> Below messages are calltrace.

Another comestic change, regarding commit log.

Instead of this large commit log, with all these call traces, I would
like to see a more comprehensive explanation per file, eg.

[...]
> 16. destroy_conntrack
> -nf_ct_destroy
> --nf_conntrack_destroy

destroy_destroy() is called from rcu protected callback function, so
rcu read side lock is already guaranteed.

[...]
> 17. __ctnetlink_glue_build

Another example: Called from packet path, netfilter hooks run under
rcu read lock side, so all packet path code is under rcu read side
lock.

If possible... No problem if you're non-native English speaker, most
of us are not, so some hints to understand why rcu_read_lock() is not
required in natural languages seems like a good fit for the git
repository IMO.

Don't get me wrong, the calltraces are fine for review, but I would
like we don't land such a loooong commit message in the netfilter
tree.

Thanks!
