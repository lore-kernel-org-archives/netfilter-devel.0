From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] update raw patch in POM
Date: Wed, 22 Jun 2005 20:38:07 +0200
Message-ID: <42B9B00F.90601@trash.net>
References: <42A6AB19.2040106@tac.ch>
	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>
	<42B67BEC.1090105@tac.ch>	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>	<20050621111328.GK8335@postel.suug.ch>
	<42B81D75.8090205@trash.net>	<20050621215027.GP8335@postel.suug.ch>
	<42B8B181.4020607@trash.net>	<20050622005243.GQ8335@postel.suug.ch>	<42B8DA09.9080406@eurodev.net>
	<42B8E141.1080902@trash.net> <42B94DFE.2070205@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <42B94DFE.2070205@tac.ch>
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
> Back with some results.
> 
> Jun 22 15:12:18 s_int@sem-arbeit NET: 11980617 messages suppressed.
> Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:23 s_int@sem-arbeit NET: 26269793 messages suppressed.
> Jun 22 15:12:23 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:28 s_int@sem-arbeit NET: 26417688 messages suppressed.
> Jun 22 15:12:28 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:33 s_int@sem-arbeit NET: 26284076 messages suppressed.
> Jun 22 15:12:33 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:38 s_int@sem-arbeit NET: 26310362 messages suppressed.
> Jun 22 15:12:38 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:43 s_int@sem-arbeit NET: 26308346 messages suppressed.
> Jun 22 15:12:43 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:48 s_int@sem-arbeit NET: 26244255 messages suppressed.
> Jun 22 15:12:48 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
> Jun 22 15:12:53 s_int@sem-arbeit ip_conntrack version 2.1 (8192
buckets, 65536 max) - 324 bytes per conntrack

This actually looks good, no leak, no crash. Not sure where the 30
second delay comes from, my guess is that packets are queued while
the neighbour is resolved, although its pretty long. To confirm that
theory you could play with the values in
/proc/sys/net/ipv4/neigh/default and see if it changes anything.

You said in an earlier mail regarding the wait-for-untracked-references
patch:

> This results in an endless loop when calling rmmod ip_conntrack. lsmod
> shows (deleted) but the process is in D state. No oops of course and
> no hang.
>
> But I cannot remove the ip_conntrack kernel module anymore. It's
> "stuck".

How long did you wait that time?

Regards
Patrick
