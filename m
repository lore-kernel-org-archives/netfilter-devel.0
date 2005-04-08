From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] Conntrack targets/matches work with nfconntrack
Date: Fri, 08 Apr 2005 10:23:02 +0200
Message-ID: <42563F66.8030200@eurodev.net>
References: <424F0DD6.9070002@eurodev.net>
	<200504080809.j3889P1Y001851@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200504080809.j3889P1Y001851@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Pablo Neira <pablo@eurodev.net>
> Date: Sat, 02 Apr 2005 23:25:42 +0200
> 
> 
>>Hi,
>>
>>This patch makes work conntrack related matches and targets with both 
>>ip_conntrack and nf_conntrack (ipt_state, ipt_CONNMARK, ipt_connmark, 
>>ipt_NOTRACK, ipt_conntrack). Two comments about this:
>>
>>o I've slighty modified the ip_conntrack structure to make it look like 
>>nf_conntrack.
>>
>>-               u_int32_t ip;
>>+               union {
>>+                       u_int32_t ip;
>>+               } u3;
>>
>>o This patch adds some ifdef's. I understand that this isn't the more 
>>elegant way to do this but it's rather straight forward. I think that 
>>this solution is not that bad since ip_conntrack will dissapear some day 
>>together with those ifdef's.
> 
> 
> This causes compatibility problem (at least, libipt_conntrack.c of iptables).
> Then this patch is acceptable for me if we can easily fix it.

No problem, Rusty had the same problem when he modified the layout of 
ip_conntrack_tuple. Have a look at struct ip_conntrack_old_tuple in 
ipt_conntrack.h.

Anyway I don't see any obvious way to make work NAT code yet.

--
Pablo
