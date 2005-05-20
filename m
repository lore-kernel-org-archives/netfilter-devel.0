From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipalter/ipset
Date: Fri, 20 May 2005 14:33:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0505201429030.13712@blackhole.kfki.hu>
References: <428824A7.3060506@elte.hu>
	<Pine.LNX.4.58.0505180901460.9582@blackhole.kfki.hu>
	<428CF8B3.5030408@nuk.teteny.elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Kirk <kirk@nuk.teteny.elte.hu>
In-Reply-To: <428CF8B3.5030408@nuk.teteny.elte.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 19 May 2005, Kirk wrote:

> > What's wrong with the normal negation?
> example:
> ipset -N ports_level_0	--invert --from 1 --to 1
> ipset -N ports_level_1	--from 1 --to 1024
> ipset -N ports_level_X	--from 1 --to 1
> ipset -A ports_level_1	22
> ipset -A ports_level_1	80
> ipset -N in_map	ipmap	--netwrok 10.0.0.0/24
> ipset -A in_map 10.0.0.1
> ipset -A in_map 10.0.0.2
> [...]
> ipset -B in_map 10.0.0.1 ports_level_0
> ipset -B in_map 10.0.0.2 ports_level_1
> [...]
> ipset -B in_map :default: ports_level_X
>
> iptables -P FORWARD DROP
> iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
> iptables -A FORWARD -i eth0 -s 10.0.0.0/24 -j ACCEPT
> iptables -A FORWARD -m set --set in_map dst,dst	-j ACCEPT
>
> and if requested i can change 10.0.0.2's visible ports to all,
> without having another ipmap to describe the set of those machines that are ok to run services on any port..

Nice! I'll add --invert (or better named as --negate?) as a generic
feature to any set types in the forthcoming release.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
