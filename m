From: Patrick McHardy <kaber@trash.net>
Subject: Re: Unable to build iptables on linux kernel 2.6.10 + 2.6.11-rc2
 +	2.6.11-rc2-bk5
Date: Tue, 01 Feb 2005 14:17:10 +0100
Message-ID: <41FF8156.4090802@trash.net>
References: <200501271553.j0RFr747004108@StraightRunning.com>
	<41FD5F3C.1060009@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Colin Harrison <colin.harrison@virgin.net>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41FD5F3C.1060009@eurodev.net>
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

Pablo Neira wrote:

> u8 seems not to be defined in user space, that's why iptables 
> complains in compilation time. A quick grep at /usr/include on my 
> laptop tells me that such definition doesn't exist in user space. 
> AFAICS it's only defined in kernel space. So, I've renamed it to 
> u_int8_t and that fixed the problem.
>
> Patrick, if this is the best way to fix this problem, are you willing 
> to add it to your patchset?

It's the easiest way :)

Applied, thanks.
