From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Stange ip_conntrack (newnat) behaviour.
Date: Mon, 3 Jun 2002 12:03:29 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206031154180.4553-100000@blackhole.kfki.hu>
References: <200206020845.g528jCj06987@mint.home.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "A. van Schie" <a.van.schie@quicknet.nl>
In-Reply-To: <200206020845.g528jCj06987@mint.home.net>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Sun, 2 Jun 2002, A. van Schie wrote:

> I saw something strange that I think comes from ip_conntrack.
>
> I'm using conntrack-state to filter my packets.
> A simple version of my rules look like this:
>   iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
>   iptables -A OUTPUT -m state --state NEW -p tcp --destination-port 110 -j log+accept
>   ...
>   iptables -A OUTPUT -j log+drop
>
>   iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
>   iptables -A INPUT -j log+drop
>
> What I see with ULOG is the following:
> +------+------------+------+------+-----------------+--------+-------+--------+-------+---------+-------+------------+------------+------------+---------+---------+
> | id   | prefix     | in   | out  | time            | saddr  | sport | daddr  | dport | ip_csum | ip_id | ip_fragoff | tcp_seq    | tcp_ackseq | tcp_ack | tcp_syn |
> +------+------------+------+------+-----------------+--------+-------+--------+-------+---------+-------+------------+------------+------------+---------+---------+
> | 8603 | ACCEPT-NEW |      | eth1 | 18:38:10.389606 | client | 38136 | server |   110 |       0 |     0 |          0 | 4080432246 |          0 |    NULL |       1 |
> | 8604 | ACCEPT-NEW |      | eth1 | 18:38:10.389606 | client | 38136 | server |   110 |   21509 | 13068 |          0 | 4080432246 |          0 |    NULL |       1 |
> | 8605 | DROPPED    | eth1 |      | 18:38:10.397096 | server |   110 | client | 38136 |   62367 | 56184 |      16384 | 3577899487 | 4080432247 |       1 |    NULL |
> | 8606 | ACCEPT-NEW |      | eth1 | 18:38:16.389606 | client | 38136 | server |   110 |   21508 | 13069 |          0 | 4080432246 |          0 |    NULL |       1 |
> | 8607 | DROPPED    | eth1 |      | 18:38:16.403816 | server |   110 | client | 38136 |   62365 | 56186 |      16384 | 3577899487 | 4080432247 |       1 |    NULL |
> | 8608 | ACCEPT-NEW |      | eth1 | 18:39:55.286423 | client | 38137 | server |   110 |    1024 |     0 |          0 | 4184019953 |          0 |    NULL |       1 |
> +------+------------+------+------+-----------------+--------+-------+--------+-------+---------+-------+------------+------------+------------+---------+---------+
> All other fields are equal.
>
> What I find strange is that it starts with 2 almost the same packets (except for ip_id),
> and that they both get the conntrack state NEW!

What else state should they got? But those first two packets looks
strange, that's true.

> I think there is a problem in conntrack,
> maybe the newnat patch or the "double packet" is introduced in the kernel.

If you suspect something like that, then start tcpdumping both involved
interfaces and look at the generated logs.

Did you applied other patches from p-o-m?

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
