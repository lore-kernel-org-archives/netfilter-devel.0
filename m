From: Patrick McHardy <kaber@trash.net>
Subject: Re: masquerade & ipsec
Date: Wed, 05 Jul 2006 17:34:45 +0200
Message-ID: <44ABDC15.9050606@trash.net>
References: <44A6FDDE.8050805@seclark.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen.Clark@seclark.us
In-Reply-To: <44A6FDDE.8050805@seclark.us>
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

Stephen Clark wrote:
> Hello,
> 
> I am running kernel 2.6.16-1.2115_FC4 - I have network that looks like
> this:
>                                           
> FreeBSD                                           FC-4
> 10.0.128.0/17 <-> 10.0.254.254-65.162.x.x ipsec tunnel
> 24.x.x.x-192.168.2.1 <-> 192.168.2.0/24
> 
> Some change recently caused masquerading to happen on my FC-4 box before
> ipsec happens
> so my packets from my 192.168.2.0/24 network have the source address
> changed to my external interface address and don't get picked up by the
> SA. If I turn off masquerading
> then ipsec works again. I didn't use to have this problem.

You can use the policy match to exclude the packets that should
be handled by IPsec from masquerading. Or simple do it by
address.
