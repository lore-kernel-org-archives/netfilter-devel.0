From: Phil Oester <kernel@linuxace.com>
Subject: Re: ipt_limit patch for iptables-1.3.1 and linux-2.4.22
Date: Fri, 23 Dec 2005 12:57:11 -0800
Message-ID: <20051223205711.GA28855@linuxace.com>
References: <5210898791.20051223141249@uu3.net> <43ABFE4B.6040102@cineca.it>
	<3519928555.20051223164319@uu3.net>
	<43AC4F57.8090702@trash.net> <036110574.20051223211301@uu3.net>
	<20051223201951.GA28723@linuxace.com>
	<16937451772.20051223213523@uu3.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: borg@uu3.net
Content-Disposition: inline
In-Reply-To: <16937451772.20051223213523@uu3.net>
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

On Fri, Dec 23, 2005 at 09:35:23PM +0100, borg@uu3.net wrote:
> Okey.. So you saying that my system is broken?
> I have patched kernel + iptables.. installed new
> kernel + iptables.. but userland is not updated..
> It it bad?
> I know it is when there are major changes in kernel
> so userspace cannot see them. But in that case I think
> its not a big problem since this is only used in iptables?

iptables == userspace.

If 2.4.33 were to suddenly have a new version of the limit match,
then anyone using an older iptables would be broken if they 
upgraded to it.

So while _you_ may have updated your kernel and iptables,
the rest of the world has not.  Backwards compatibility is
important.

If you need limit inversion, please update to 2.6.x kernels
where this feature exists.  If you still do not understand,
please search the archives for additional information.

Phil
