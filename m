From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] update raw patch in POM [2.4.x]
Date: Tue, 21 Jun 2005 17:32:35 +0200
Message-ID: <42B83313.2030505@trash.net>
References: <42A57FC4.7010508@tac.ch>	<42A5B144.3090005@tac.ch>	<42A625DA.7090807@eurodev.net>	<42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>	<42B67BEC.1090105@tac.ch>	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>	<20050621111328.GK8335@postel.suug.ch>
	<42B81D75.8090205@trash.net> <42B82177.5010101@tac.ch>
	<42B8288C.9030004@trash.net> <42B82F29.40307@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <42B82F29.40307@tac.ch>
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

Roberto Nibali wrote:
>>>Do you want me to rerun the test for more precise statements?
>>
>>Yes, please make sure no packets are queued in qdiscs (best to use
>>pfifo) and no raw/packet sockets are open and ip_queue isn't used.
> 
> 
> # tc qdisc show
> qdisc pfifo_fast 0: dev eth0 [Unknown qdisc, optlen=20]
> qdisc pfifo_fast 0: dev eth1 [Unknown qdisc, optlen=20]
> 
> # cat /proc/net/raw
>   sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt
> uid  timeout inode
> 
> ip_queue is not used. Following modules are loaded when our small ruleset is set:

What about packet sockets? raw sockets actually don't matter, the
reference is dropped before it reaches them. Please send me the raw
table patch you're using.

Regards
Patrick
