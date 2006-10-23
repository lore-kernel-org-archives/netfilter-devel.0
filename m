From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problem using connection tracking
Date: Mon, 23 Oct 2006 18:25:16 +0200
Message-ID: <453CECEC.3090807@trash.net>
References: <J7LHCP$FF41A5B70ACBDAD6AAEB334FF0D11DDC@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "mael.boutin" <mael.boutin@laposte.net>
In-Reply-To: <J7LHCP$FF41A5B70ACBDAD6AAEB334FF0D11DDC@laposte.net>
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

mael.boutin wrote:
> Hi,
> 
> First excuse me for my poor english ...
> 
> I'm having problems using conntrack. Everything was ok while i
> was using the old ip_conntrack. However, now i need to use it
> with IPv6.
> 
> The problem i'm facing is with the new connection tracking
> system, i can't receive any conntrack events neither IPv4 nor
> IPv6.
> 
> Moreover, the conntrack application is not working :
> - conntrack -L returns invalid parameters
> - conntrack -E dumps nothing
> 
> I think it is a problem related with the configuration of the
> kernel (attached).
> 
> I'm using a 2.6.15.6 Linux Kernel and i can't go to a newer
> kernel. 

ctnetlink support for nf_conntrack was added in 2.6.16.
