From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Patch net v2] xt_RATEEST: acquire xt_rateest_mutex for hash
 insert
Date: Mon, 05 Feb 2018 15:25:11 -0800
Message-ID: <1517873111.3715.146.camel@gmail.com>
References: <20180205224145.9420-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f44.google.com ([209.85.160.44]:37849 "EHLO
        mail-pl0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750855AbeBEXZN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Feb 2018 18:25:13 -0500
In-Reply-To: <20180205224145.9420-1-xiyou.wangcong@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2018-02-05 at 14:41 -0800, Cong Wang wrote:
> rateest_hash is supposed to be protected by xt_rateest_mutex,
> and, as suggested by Eric, lookup and insert should be atomic,
> so we should acquire the xt_rateest_mutex once for both.
> 
> So introduce a non-locking helper for internal use and keep the
> locking one for external.
> 
> Reported-by: <syzbot+5cb189720978275e4c75@syzkaller.appspotmail.com>
> Fixes: 5859034d7eb8 ("[NETFILTER]: x_tables: add RATEEST target")
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

