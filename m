From: Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH V2] netfilter: Remove duplicated rcu_read_lock.
Date: Mon, 5 Jun 2017 21:59:11 +0300 (EEST)
Message-ID: <alpine.LFD.2.20.1706052155480.7008@ja.home.ssi.bg>
References: <20170605152125.24978-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ja.ssi.bg ([178.16.129.10]:34662 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751170AbdFES7T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2017 14:59:19 -0400
In-Reply-To: <20170605152125.24978-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


	Hello,

On Tue, 6 Jun 2017, Taehee Yoo wrote:

> Some functions are called by nf_hook() and these
> functions hold rcu_read_lock() But nf_hook() already holds
> rcu_read_lock() therefore callee's rcu_read_lock() are useless.

...

> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

	IPVS part looks ok to me,

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
> 
> V2:
>    - Remove comments.
>    - The rcu_read_lock under below functions are removed.
>     - {tcp, udp, sctp}_app_conn_bind,
>     - ip_vs_bypass_xmit,
>     - ip_vs_bypass_xmit_v6,
>     - ip_vs_nat_xmit,
>     - ip_vs_nat_xmit_v6,
>     - ip_vs_tunnel_xmit,
>     - ip_vs_tunnel_xmit_v6
>     - ip_vs_dr_xmit,
>     - ip_vs_dr_xmit_v6
>     - destroy_conntrack,
>     - __ctnetlink_glue_build,
>     - ctnetlink_expect_event,
>     - ctnetlink_proto_size,
>     - ctnetlink_conntrack_event,
>     - nfqnl_nf_hook_drop,
>     - tproxy_laddr6.
> 
> V1:
>    - Initial version

...

Regards

--
Julian Anastasov <ja@ssi.bg>
