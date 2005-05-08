From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ctnetlink weird events on ipsec connections
Date: Sun, 08 May 2005 13:49:14 +0200
Message-ID: <427DFCBA.5090702@eurodev.net>
References: <1115048084.12112.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas <toom@docisland.org>
In-Reply-To: <1115048084.12112.52.camel@localhost.localdomain>
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

Thomas wrote:
> Hello,
> 
> I recently tried the new ip_conntrack_netlink feature and I got a weird
> result with ipsec connections : 
> # conntrack -E conntrack
> [DESTROY] src=<VPNGW_1> dst=<VPNGW_2>
>           src=<VPNGW_2> dst=<VPNGW_1> timeout:180
>           orig_packets=8391 orig_bytes=1252012,
>           reply_packets=19 reply_bytes=11424 
> [DESTROY] src=<INTERNAL_IP1> dst=<INTERNAL_IP2>
>           src=<INTERNAL_IP2> dst=<INTERNAL_IP1> timeout:432000
>           orig_packets=7763 orig_bytes=572775,
>           reply_packets=5219 reply_bytes=1209729 
> [DESTROY] src=<VPNGW_1> dst=<VPNGW_2>
>           src=<VPNGW_2> dst=<VPNGW_1> timeout:180
>           orig_packets=8392 orig_bytes=1252140,
>           reply_packets=19 reply_bytes=11424 
> [

DESTROY] src=<INTERNAL_IP1> dst=<INTERNAL_IP2>
>           src=<INTERNAL_IP2> dst=<INTERNAL_IP1> timeout:432000
>           orig_packets=7764 orig_bytes=572827,
>           reply_packets=5221 reply_bytes=1210553 
> and so on ...
> 
> both INTERNAL_IP2 and VPNGW_2 ip are in the same host where I run
> conntrack tool.

I recently posted a patch to delete the use of nfcache in ip_tables, 
this causes some interferences to the conntrack-event-api. I think that 
it could be related to your problem.

https://lists.netfilter.org/pipermail/netfilter-devel/2005-May/019574.html

Could you give it a try and let me know if it fixes your problem?

--
Pablo
