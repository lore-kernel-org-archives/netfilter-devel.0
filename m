From: borg@uu3.net
Subject: Re[2]: ipt_limit patch for iptables-1.3.1 and linux-2.4.22
Date: Fri, 23 Dec 2005 21:13:01 +0100
Message-ID: <036110574.20051223211301@uu3.net>
References: <5210898791.20051223141249@uu3.net> <43ABFE4B.6040102@cineca.it>
	<3519928555.20051223164319@uu3.net> <43AC4F57.8090702@trash.net>
Reply-To: borg@uu3.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-reply-To: <43AC4F57.8090702@trash.net>
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

Well.. patching only kernel or only userland is pointless indeed.
I still dont understand "brakes userspace"
I assume that we patch both iptables + kernel.
Where is the problem then?

Back to adding that to mainline...
First, ppl must have add this to kernel.
and after kernel.. you can add it to new iptables
its easy to detect what kernel is in use
by #ifdef and you can add/remove support for !
in libipt_limit.c.

Regards,
Borg

----- Original Message -----
From: kaber@trash.net
To: borg@uu3.net
Date: 23-12-2005, 20:26
Subject: ipt_limit patch for iptables-1.3.1 and linux-2.4.22

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
