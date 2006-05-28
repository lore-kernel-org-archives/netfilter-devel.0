From: Patrick McHardy <kaber@trash.net>
Subject: Re: Query: status of ipt_recent?
Date: Mon, 29 May 2006 01:25:28 +0200
Message-ID: <447A3168.4030308@trash.net>
References: <45ai725cka9svjijcg1qnbm5fcd90uq4c1@4ax.com>	<447991F7.6030808@trash.net>
	<71bk725lasf680d0d94h79bbpanlap0hju@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Grant Coady <gcoady.lk@gmail.com>
In-Reply-To: <71bk725lasf680d0d94h79bbpanlap0hju@4ax.com>
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

Grant Coady wrote:
> On Sun, 28 May 2006 14:05:11 +0200, Patrick McHardy <kaber@trash.net> wrote:
> 
>>The problem with the recent match is mostly that its an offence
>>to the eyes and very hard to maintain, even small and simple patches
>>are hard to review. As far as I know it works fine if you forget
>>about a few corner cases, so I don't really see a reason for a
>>backport. Shouldn't be very hard though.
> 
> 
> I use 2.4.latest on firewall box and was using iptables --recent 
> for web server traffic calming (on tiny pipe to 'net) by src_ip 
> to prevent DoS by some users.  I hadn't noticed memory leak, 
> perhaps 'cos uptime max is in weeks, and I unload/reload ipt_recent 
> 'cos firewall sets parameters (more entries, less history):
> 
>         report "    reload --recent (250 x 2)"
>         rmmod ipt_recent
>         # see man iptables for this:
>         modprobe ipt_recent ip_list_tot=250 ip_pkt_list_tot=2
> 
> each time I fiddle with the iptables ruleset.

The leak only happens on an error path under very unlikely
circumstances.

> If the author has abandoned the thing I could reformat it, throw 
> in some function calls to convert the spaghetti code to functions, 
> make it easier to see the obfuscated control flow, and throw in 
> some goto targets as well ;)  (CodingStyle single exit)
> 
> I'd hate to duplicate a work in progress.  

Well, for 2.6 we have a replacement now. For 2.4 such a patch would
be too intrusive, so you would have to maintain it yourself out of
tree.
