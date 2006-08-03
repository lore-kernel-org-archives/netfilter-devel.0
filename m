From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack utility..
Date: Thu, 03 Aug 2006 21:15:25 +0200
Message-ID: <44D24B4D.5080402@netfilter.org>
References: <416697d80608020725i1f7bcf15nfa487a702de662@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Devrim Seral <dseral@gmail.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <416697d80608020725i1f7bcf15nfa487a702de662@mail.gmail.com>
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

Hi,

Devrim Seral wrote
> For a few days i tried to fix some problem to handle events int 
> conntrack utility.. However i haven't success..
> i learned conntrack notification feature from Harald Welte paper. And 
> also i find conntrack utility from netfilter.org <http://netfilter.org>..
> 
> I am using libnetfilter_conntrack-0.0.31, libnfnetlink-0.0.16 and 
> conntrack-1.00beta2 on ubuntu server 6 with kernel 2.6.15 64 bit kernel.
> Everything seem ok except show events feature..
> I am tried to solve but still i am not get any result..
> i tried to watch events with command like :
> ./conntrack -E
> ./conntrack -E conntrack
> ./conntrack -E conntrack -e DESTROY
> 
> Neither command give me any result.. Only when i pressed Ctrl+C 
> conntrack utility give output "Now closing conntrack event dumping..."

Please, make sure that ip_conntrack_netlink module is loaded (modprobe 
ip_conntrack_netlink). Let me know if that fixes your problem.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
