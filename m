From: Sander Smeenk <ssmeenk+netfilter@freshdot.net>
Subject: Re: ip_conntrack_in: Frag of proto 17
Date: Sat, 14 Aug 2004 16:24:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040814142407.GD7528@freshdot.net>
References: <1089646231.3157.23.camel@scratch.dynamic.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <1089646231.3157.23.camel@scratch.dynamic.vt.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Quoting Tim Rhodes (rhodes@vt.edu):

> Is there any additional information/understanding of this condition. 

It has to do with the size of UDP packets, as I understood. The packets
can not exceed 8K in size or ip_conntrack_in starts messing up.

You can test this by mounting an nfs share locally, and play with
rsize/wsize parameters.

> Is there and if so, what's the limit.

There is. 8K. Exceed that and it will fail.

What I don't understand is WHY this limit suddenly appeared, and why
there's so little discussion about it. I think this is a really big
problem, since not all tools that do UDP can (easily) be told to use
blocks of <= 8192 bytes. For example, my sfs shares are now completely
useless, which bites me ever since I switched to kernels >2.6.5.

Yet, nobody knows why this change was made, or what can be done to work
around it. I *HAD* a working solution: no udp tracking:
	ipv4 -t raw -A PREROUTING -p udp -j NOTRACK
	ipv4 -A FORWARD -m state --state UNTRACKED -j ACCEPT
but that stopped working with kernels >2.6.7.

So, can anyone from the netfilter-dev team shed some light?

Thanks,
Sander.
-- 
| There's nothing like waking up with your Dickin's Cider!
| 1024D/08CEC94D - 34B3 3314 B146 E13C 70C8  9BDB D463 7E41 08CE C94D
