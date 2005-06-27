From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] update raw patch in POM
Date: Mon, 27 Jun 2005 14:55:12 +0200
Message-ID: <42BFF730.2080300@trash.net>
References: <42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>	<42B67BEC.1090105@tac.ch>	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>	<20050621111328.GK8335@postel.suug.ch>	<42B81D75.8090205@trash.net>	<20050621215027.GP8335@postel.suug.ch>	<42B8B181.4020607@trash.net>	<20050622005243.GQ8335@postel.suug.ch>	<42B8DA09.9080406@eurodev.net>	<42B8E141.1080902@trash.net>	<42B94DFE.2070205@tac.ch>
	<42B9B00F.90601@trash.net>	<42BF9E5D.4000705@tac.ch>
	<42BFDBA1.7060002@trash.net> <42BFEC10.20102@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <42BFEC10.20102@tac.ch>
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
>>Try halving all values and see if it has any effects on the time
>>it takes to unload the module.
> 
> Nope, I'll upload the new results shortly but the time is unchanged.
> 

Hmm I'm out of ideas.

>>I'm pretty sure the nf_reset + the wait-for-untracked-refs patches
>>should take care of the problem, but to be sure it would be good
>>to know where the delay came from.
> 
> Currently I do not run it with nf_reset patched kernels which is another really
> strange thing. Some other timeout which is 30s? But I only see
> udp_timeout_stream and icmp_timeout ...

If the nf_reset patch helps it must be somewhere after
ip_finish_output2(). This could be an arp queue, a device queue
or a packet socket queue. You could add an nf_reset to dev_queue_xmit
and see if it changes anything.

> Do you plan to submit the nf_reset and wait-for-untracked-refs patches for
> mainline inclusion?

There's no raw table in 2.4, so the wait-for-untracked-refs patch should
go in the 2.4 raw table patch. For 2.6 I'm not sure yet, Pablo has a
patch that changes how untracked works and makes this patch unnecessary.
The nf_reset patch with go in my next 2.4 update, which should happen
soon.

Regards
Patrick
