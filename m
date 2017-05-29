From: Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH] netfilter: Remove duplicated rcu_read_lock.
Date: Tue, 30 May 2017 00:12:04 +0900
Message-ID: <CAMArcTXviyp7acsv+eRYW7yGseWj+THLQ4GPg04NJieTd3SegA@mail.gmail.com>
References: <alpine.LFD.2.20.1705241508270.9575@ja.home.ssi.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, lvs-devel@vger.kernel.org
To: Julian Anastasov <ja@ssi.bg>
Return-path: <lvs-devel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1705241508270.9575@ja.home.ssi.bg>
Sender: lvs-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

2017-05-24 21:25 GMT+09:00 Julian Anastasov <ja@ssi.bg>:
>
>         Hello,
>
>         The IPVS part from patch looks good but can be extended
> to also remove rcu_read_lock and rcu_read_unlock from:
>
> 1. all app_conn_bind methods because ip_vs_bind_app() is called
> always under RCU lock from ip_vs_try_bind_dest() and ip_vs_conn_new().
> I.e. from sctp_app_conn_bind, tcp_app_conn_bind and udp_app_conn_bind.
>
> 2. ip_vs_xmit.c, all locks
>
>         IMHO, using comments instead of locks is not needed, it is
> enough that the commit message explains why RCU locks are removed
>
I agree that. so I'll remove comments in v2 patch.

>         More details:
>
> In IPVS we have the following contexts:
> - packet RX/TX: does not need locks because packets come from hooks
> - sync msg RX: backup server uses RCU locks while registering new conns
> - ip_vs_ctl.c: configuration get/set, RCU locks needed
> - xt_ipvs.c: It is a NF match
>
This comments are very helpful for me.

> As result, rcu_read_lock and rcu_read_unlock can be removed from:
> - ip_vs_core.c: all
> - ip_vs_ctl.c:
>         - from ip_vs_has_real_service
>         - all other places need the RCU locking
> - ip_vs_ftp.c: all
> - ip_vs_proto_sctp.c: all
> - ip_vs_proto_tcp.c: all
> - ip_vs_proto_udp.c: all
> - ip_vs_xmit.c: all (contains only packet processing)
>
> Locks should remain in:
> - ip_vs_conn.c
> - ip_vs_pe.c
> - ip_vs_sync.c
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>

Thank you so much for helpful review!
I'll make a v2 patch included your suggestion.

Thanks a lot!
