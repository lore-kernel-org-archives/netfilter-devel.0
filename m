From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net] netfilter: unlock xt_table earlier in __do_replace
Date: Fri, 16 Feb 2018 12:02:45 +0100
Message-ID: <20180216110245.GB31046@breakpoint.cc>
References: <61f106376f836829d8c283fb4c0cf11567c953bf.1518775496.git.lucien.xin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        pablo@netfilter.org, fw@strlen.de
To: Xin Long <lucien.xin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50724 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934998AbeBPLGG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 06:06:06 -0500
Content-Disposition: inline
In-Reply-To: <61f106376f836829d8c283fb4c0cf11567c953bf.1518775496.git.lucien.xin@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Xin Long <lucien.xin@gmail.com> wrote:
> Now it's doing cleanup_entry for oldinfo under the xt_table lock,
> but it's not really necessary. After the replacement job is done
> in xt_replace_table, oldinfo is not used elsewhere any more, and
> it can be freed without xt_table lock safely.

Right.

> The important thing is that rtnl_lock is called in some xt_target
> destroy, which means rtnl_lock, a big lock is used in xt_table
> lock, a smaller one. It usually could be the reason why a dead
> lock may happen.

In which cases do we aquire the xt table mutex from places that hold
rtnl mutex?

> Besides, all xt_target/match checkentry is called out of xt_table
> lock. It's better also to move all cleanup_entry calling out of
> xt_table lock, just as do_replace_finish does for ebtables.

Agree but I don't see how this patch fixes a bug so I would prefer if
this could simmer in nf-next first.
