From: Patrick McHardy <kaber@trash.net>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Thu, 04 Oct 2007 08:15:53 +0200
Message-ID: <47048519.50701@trash.net>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl> <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41121 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbXJDGQh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 02:16:37 -0400
In-Reply-To: <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Krzysztof Oledzki wrote:
> Small update to this issue. It seems that both ip stack and netfilter
> indeed handle connections using different timers:
> 
> # wget --bind-address 192.168.0.1 192.168.129.28 -O /dev/null
> 
> --14:36:00--  http://192.168.129.28/
>            => `/dev/null'
> Connecting to 192.168.129.28:80... connected.
> HTTP request sent, awaiting response... 200 OK
> Length: 915 [text/html]
> 
> 100%[==========================================================================================>]
> 915           --.--K/s
> 
> 14:36:00 (13.43 MB/s) - `/dev/null' saved [915/915]
> 
> # conntrack -L |grep =192.168.129.28|grep 192.168.0.1:
> tcp      6 119 TIME_WAIT src=192.168.0.1 dst=192.168.129.28 sport=18300
> dport=80 packets=6 bytes=422 src=192.168.129.28 dst=192.168.0.1 sport=80
> dport=18300 packets=4 bytes=1475 [ASSURED] mark=0 use=1
> 
> # ss -anto |egrep "192.168.0.1.*192.168.129.28":
> TIME-WAIT  0      0               192.168.0.1:18300      
> 192.168.129.28:80     timer:(timewait,58sec,0)
> 
> 
> After 60s kernel is able to reuse this (18300) port but it will be
> blocked by local netfilter with this "invalid SYN" message. This is
> especially more likely in newer kernels with tcp port randomization.
> 
> This does not solve my problem but it think we should consider changing
> net.ipv4.netfilter.ip_conntrack_tcp_timeout_time_wait from 120s to 60s.


As you quoted below, we should use 2*MSL, which would actually be
240s. Not sure why Linux TCP uses 60s ..

> 
> I also wondering if the code from nf_conntrack_proto_tcp.c is correct:
> 
> --- cut here ---
> new_state = tcp_conntracks[dir][index][old_state];
> 
> switch (new_state)
> (...)
> case TCP_CONNTRACK_SYN_SENT:
> if (old_state < TCP_CONNTRACK_TIME_WAIT)
>         break;
> if ((conntrack->proto.tcp.seen[dir].flags &
>         IP_CT_TCP_FLAG_CLOSE_INIT)
>     || after(ntohl(th->seq),
>              conntrack->proto.tcp.seen[dir].td_end)) {
>         /* Attempt to reopen a closed connection.
>         * Delete this connection and look up again. */
>         write_unlock_bh(&tcp_lock);
>         if (del_timer(&conntrack->timeout))
>                 conntrack->timeout.function((unsigned long)
>                                             conntrack);
>         return -NF_REPEAT;
> } else {
>         write_unlock_bh(&tcp_lock);
>         if (LOG_INVALID(IPPROTO_TCP))
>                 nf_log_packet(pf, 0, skb, NULL, NULL,
>                               NULL, "nf_ct_tcp: invalid SYN");
>         return -NF_ACCEPT;
> }
> --- cut here ---
> 
> It seems that tcp_conntracks allows such (TCP_CONNTRACK_TIME_WAIT ->
> TCP_CONNTRACK_SYN_SENT) transition, pointing to rfc1122:
> 
> When a connection is closed actively, it MUST linger in
> TIME-WAIT state for a time 2xMSL (Maximum Segment Lifetime).
> However, it MAY accept a new SYN from the remote TCP to
> reopen the connection directly from TIME-WAIT state, if it:
> 
> (1)  assigns its initial sequence number for the new
>      connection to be larger than the largest sequence
>      number it used on the previous connection incarnation,
>      and
> 
> (2)  returns to TIME-WAIT state if the SYN turns out to be
>      an old duplicate.
> 
> So, it seems that this "after(...)" does not match this packet, right?
> 
> Patric, what do you think about this?


Yes, that seems to be the case. Could you post a tcpdump (and
add a few printks printing the td_end and the flag values
of both directions if possible)?
