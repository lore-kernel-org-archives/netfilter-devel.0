From: Patrick McHardy <kaber@trash.net>
Subject: Re: Kernel Oops with kernel 2.4.25 and iptables 1.2.9 in __unexpect_related
Date: Tue, 15 Jun 2004 10:31:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40CEB3DA.5070401@trash.net>
References: <002401c452ac$06523580$7c01a8c0@std.visionutv.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter Olsson <aa@tbh.se>
In-Reply-To: <002401c452ac$06523580$7c01a8c0@std.visionutv.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Peter Olsson wrote:
> After running my firewall without any problems for about 90 days, I 
> suddenly got a Kernel Oops.
> When running it through ksymoops I received the result below.
>  
> I've read a few comments about a bug in the newnat code in 
> unexpect_related, but what I can see
> this should be fixed a long time ago, and if I compare the 
> unexpect_related calls in the ip_conntrack_core.c
> from version 2.4.25 til 2.4.26 they work in exactly the same way. Could 
> there be something else causing
> this problem? I don't think it's hardware related, I've been using the 
> same hardware, but with kernel 2.4.27
> for about a year before this happened, and it's been working really good.

We are at 2.4.27-pre5 now ..

It looks like the list is uninitialized in list_del. Have you applied
any other patches besides pptp_conntrack_nat ?

Regards
Patrick
