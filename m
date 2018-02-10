From: Eric Biggers <ebiggers3@gmail.com>
Subject: Apply "netfilter: nf_queue: Make the queue_handler pernet" to
 4.4-stable
Date: Fri, 9 Feb 2018 16:19:06 -0800
Message-ID: <20180210001906.GA134644@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34108 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753300AbeBJATJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Feb 2018 19:19:09 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Greg, can you please apply commit dc3ee32e96d7 ("netfilter: nf_queue: Make
the queue_handler pernet") to 4.4-stable?  syzbot is hitting the crash in
nfqnl_nf_hook_drop() by interrupting thread creation in pg_net_init().  An OOM
condition is not required, contrary to what is suggested by the original commit
message.

Thanks,

Eric
