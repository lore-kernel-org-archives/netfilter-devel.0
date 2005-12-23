From: borg@uu3.net
Subject: Re[2]: ipt_limit patch for iptables-1.3.1 and linux-2.4.22
Date: Fri, 23 Dec 2005 21:35:23 +0100
Message-ID: <16937451772.20051223213523@uu3.net>
References: <5210898791.20051223141249@uu3.net> <43ABFE4B.6040102@cineca.it>
	<3519928555.20051223164319@uu3.net> <43AC4F57.8090702@trash.net>
	<036110574.20051223211301@uu3.net>
	<20051223201951.GA28723@linuxace.com>
Reply-To: borg@uu3.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-reply-To: <20051223201951.GA28723@linuxace.com>
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

Okey.. So you saying that my system is broken?
I have patched kernel + iptables.. installed new
kernel + iptables.. but userland is not updated..
It it bad?
I know it is when there are major changes in kernel
so userspace cannot see them. But in that case I think
its not a big problem since this is only used in iptables?

I know that its necessary to rebuild world when new kernel
comes... but I think, this is not a case in that situation.

Or am I wrong again?

Thx for your patience,
Borg

----- Original Message -----
From: kernel@linuxace.com
To: borg@uu3.net
Date: 23-12-2005, 21:19
Subject: ipt_limit patch for iptables-1.3.1 and linux-2.4.22

On Fri, Dec 23, 2005 at 09:13:01PM +0100, borg@uu3.net wrote:
> Well.. patching only kernel or only userland is pointless indeed.
> I still dont understand "brakes userspace"
> I assume that we patch both iptables + kernel.

new kernel + old userspace = broken
old kernel + new userspace = broken

> Where is the problem then?

comprehension

Phil
