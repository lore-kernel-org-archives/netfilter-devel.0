From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: About matching (also was: Multiple Targets)
Date: Thu, 14 Apr 2005 03:09:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504140304320.16405@filer.marasystems.com>
References: <Pine.LNX.4.58.0504130857010.10437@blackhole.kfki.hu>
	<20050413071427.GC16534@oknodo.bof.de>
	<20050413152307.0312.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050413152307.0312.LARK@linux.net.cn>
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

On Wed, 13 Apr 2005, Wang Jian wrote:

> iptables -A SOMECHAIN -m this -m that -j ACTION1
> iptables -A SOMECHAIN -m this -m that -j ACTION2 (dup match)
> iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)

If we would have matches indicate if they are const for the packet or 
volatile (i.e. random) then this could all be automatic in the kernel, and 
any later tree based approaches would benefit greatly from this info. No 
need for any user action at all, just updated kernel and userspace.

on a related note hipac has a hardcoded list of "const" iptables matches 
for pretty much this reason.

Regards
Henrik
