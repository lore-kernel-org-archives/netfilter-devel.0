From: "David S. Miller" <davem@davemloft.net>
Subject: Re: iptables OOPS (all recent kernels on x86_64)
Date: Mon, 15 Nov 2004 15:15:25 -0800
Message-ID: <20041115151525.164cc207.davem@davemloft.net>
References: <41984CCC.9040800@blue-labs.org>
	<41986353.1020800@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: david+challenge-response@blue-labs.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, sri@us.ibm.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41986353.1020800@trash.net>
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

On Mon, 15 Nov 2004 09:05:39 +0100
Patrick McHardy <kaber@trash.net> wrote:

> David Ford wrote:
> 
> > Up until 2.6.9, when I changed link status after the initial 
> > configuration, I would get a kernel OOPS.  Now with 2.6.9, I get a 
> > crash immediately on boot with network device configuration.   
> > Attached is my boot log.
> 
> Apparently SCTP corrupted the inetaddr notifier chain by registering
> the same notifier_block for IPv4 and IPv6, so masq_inet_event got a
> struct inet6_ifaddr instead of a struct in_ifaddr. This patch should
> fix it.

Looks good, applied.  Thanks Patrick.

I'll apply your 2.4.x backport of this fix as well.
