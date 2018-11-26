From: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Subject: Re: 4.19.4 nf_conntrack_count kernel panic
Date: Mon, 26 Nov 2018 22:14:48 +0200
Message-ID: <2088ac5f7c2aaba6776db0f1f8528edf@nuclearcat.com>
References: <20181126194638.tpwagr7gqzvi3ogf@m.mifar.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev-owner@vger.kernel.org
To: Sami Farin <hvtaifwkbgefbaei@gmail.com>,
        Linux Networking Mailing List <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126194638.tpwagr7gqzvi3ogf@m.mifar.in>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 2018-11-26 21:46, Sami Farin wrote:
> 4.18.20 works OK, but unfortunately 4.18 series is EOL.
> I have Ryzen 1600X, 32 GB RAM, Fedora 28, gcc-8.2.1-5, nosmt=force,
> igb module for Intel I211,
> using XFS filesystems only.
> 
> To reproduce, I only do this: connect to VPN using a tunnel (e.g. 
> tun0),
> start downloading a file with qbittorrent (allow port for incoming
> TCP connections in qbittorrent and iptables) and wait a couple of 
> minutes.
> I am also using ipset and connlimit modules.
> I reproduced this bug three times.
> With 4.18 I use fq+htb and  with 4.19 I use CAKE for traffic control.
> 
> Only this message in kernel log:
> [  363.935074] TCP: request_sock_TCP: Possible SYN flooding on port
> 19044. Dropping request.  Check SNMP counters.
> I get this message with both 4.18.20 and 4.19.4.
> 
> RIP: 0010:rb_insert_color+0x64
> Call Trace:
>   nf_conntrack_count [nf_conncount]
>   ip_set_test [ip_set]
>   connlimit_mt [xt_connlimit]
>   set_match_v4 [xt_set]
>   ipt_do_table [ip_tables]
>   ip_route_input_noref
>   nf_hook_slow
>   ip_local_deliver
>   inet_add_protocol
>   ip_rcv
>   ip_rcv_finish_core
>   __netif_receive_skb_one_core
>   netif_receive_skb_internal
>   tun_rx_batched
>   tun_get_user
>   __local_bh_enable_ip
>   tun_get_user
>   tun_chr_write_iter
>   __vfs_write
>   vfs_write
>   ksys_write
>   do_syscall_64
>   trace_hardirqs_off_thunk
>   entry_SYSCALL_64_after_hwframe
> 
> ...
> 
> Kernel panic - not syncing: Fatal exception in interrupt

Check this patches:
https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=73972&state=*

Relevant discussion:
https://marc.info/?l=linux-netdev&m=154211826106430&w=2
