From: Patrick McHardy <kaber@trash.net>
Subject: Re: Kernel Oops with kernel 2.4.25 and iptables 1.2.9 in __unexpect_related
Date: Tue, 15 Jun 2004 20:06:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40CF3A95.7060302@trash.net>
References: <002401c452ac$06523580$7c01a8c0@std.visionutv.se> <40CEB3DA.5070401@trash.net> <004d01c45300$768a0a40$7c01a8c0@std.visionutv.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter Olsson <aa@tbh.se>
In-Reply-To: <004d01c45300$768a0a40$7c01a8c0@std.visionutv.se>
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
> Hi Patrick,
> 
> I meant kernel 2.4.17, not 2.4.27 :)
> 
> About other patches... I've applied a couple of other patch-o-matic patches,
> but pptp_conntrack_nat
> is the only one that seem to call anything related to the __unexpect_related
> function. I've only applied
> patches that were tested ok, not the experimental ones. The
> "__unexpect_related" has the following
> code in my version of ip_conntrack_core.c.

Well, there is at least one that won't work with pptp_conntrack_nat
(expect-optimize), so it would really help to see a list. When did
you patch your kernel with pom (roughly) ? You also didn't mention
which kernel version you ran when it crashed.

Regards
Patrick
