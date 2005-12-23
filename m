From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_limit patch for iptables-1.3.1 and linux-2.4.22
Date: Fri, 23 Dec 2005 20:26:15 +0100
Message-ID: <43AC4F57.8090702@trash.net>
References: <5210898791.20051223141249@uu3.net> <43ABFE4B.6040102@cineca.it>
	<3519928555.20051223164319@uu3.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: borg@uu3.net
In-Reply-To: <3519928555.20051223164319@uu3.net>
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

borg@uu3.net wrote:
> What do you mean it brakes userspace?
> Can you please explain me that?
> I've patched both iptables (userland),
> and kernel ipt_limit.c and header.
> The only mistake I see for now, is that I wrongly
> modified include/linux/netfilter_ipv4/ipt_limit.h
> I should add that char invert at the end of structrue.
> 
> The only userspace program using that is iptables.
> Or I am wrong?

You seem to forget about old versions that don't have your
patch. 2.4 doesn't support revisions, so we can't make
that change.
