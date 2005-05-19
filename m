From: Kirk <kirk@nuk.teteny.elte.hu>
Subject: Re: ipalter/ipset
Date: Thu, 19 May 2005 22:35:41 +0159
Message-ID: <428CF8B3.5030408@nuk.teteny.elte.hu>
References: <428824A7.3060506@elte.hu>
	<Pine.LNX.4.58.0505180901460.9582@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.58.0505180901460.9582@blackhole.kfki.hu>
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

> Hi,
> 
> What's wrong with the normal negation?
example:
ipset -N ports_level_0	--invert --from 1 --to 1
ipset -N ports_level_1	--from 1 --to 1024
ipset -N ports_level_X	--from 1 --to 1
ipset -A ports_level_1	22
ipset -A ports_level_1	80
ipset -N in_map	ipmap	--netwrok 10.0.0.0/24
ipset -A in_map 10.0.0.1
ipset -A in_map 10.0.0.2
[...]
ipset -B in_map 10.0.0.1 ports_level_0
ipset -B in_map 10.0.0.2 ports_level_1
[...]
ipset -B in_map :default: ports_level_X

iptables -P FORWARD DROP
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i eth0 -s 10.0.0.0/24 -j ACCEPT
iptables -A FORWARD -m set --set in_map dst,dst	-j ACCEPT

and if requested i can change 10.0.0.2's visible ports to all,
without having another ipmap to describe the set of those machines that are ok to run services on any port..

> Heresy - but can work in extreme situations. :-) Actually, it's a
> stateless NAT as far as I see.
yes, i know ;)
but there is any alternative for this kind of problem?

Best regards, kirk
