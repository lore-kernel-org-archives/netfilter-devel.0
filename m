From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC1812 and CLUSTERIP
Date: Thu, 26 Oct 2006 00:26:12 +0200
Message-ID: <453FE484.9090705@trash.net>
References: <1161777918.8705.63.camel@LAPTOP4.MSHOME>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: oan@frozentux.net
In-Reply-To: <1161777918.8705.63.camel@LAPTOP4.MSHOME>
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

Oskar Andreasson wrote:
> Hi all again,
> 
> I've snowed in on the CLUSTERIP target to some extent, and I am still
> figuring it out to some extent. 
> 
> One question that came to mind is its use of multicast MAC addresses. Is
> it really allowed to make use of them in the way that it is right now?
> 
> From RFC 1812 section 3.3.2:
> 
> ------
>    A router MUST not believe any ARP reply that claims that the Link
>    Layer address of another host or router is a broadcast or multicast
>    address.
> ------
> 
> As I understand it, this is exactly what the CLUSTERIP target does? 
> Behaves as if a single host has a multicast address?

I'm not too familiar with the CLUSTERIP target, what behaviour
exactly are you refering to?
