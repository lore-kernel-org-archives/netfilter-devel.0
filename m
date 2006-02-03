From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_local_deliver related query
Date: Fri, 03 Feb 2006 14:56:17 +0100
Message-ID: <43E36101.8020708@trash.net>
References: <60828.10.107.26.27.1138947199.squirrel@gpo.iitb.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Vasantha Kumar Puttappa <vasanthakumar@iitb.ac.in>
In-Reply-To: <60828.10.107.26.27.1138947199.squirrel@gpo.iitb.ac.in>
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

Vasantha Kumar Puttappa wrote:
> Hi,
> 
> ( I am assuming packet arrival to the local host)
> 
>   As far as I know Netfilter hook  for "INPUT" chain is called just before
> the ip_local_deliver() function is called. If I am not wrong,
> ip_local_deliver function will remove the IP header and gives the packet
> to appropriate function in transport layer ( TCP or UDP or ICMP
> Process).
> 
> 
>  What I am want to do is to change the source IP address of the IP packet
> just before calling the ip_local_deliver() using IPtables.
> 
> So I want know, will this go smoothly assuming there is a socket waiting
> for this kind of packet(packet with new source IP address) or will
> something go wrong ?

This is exactly what NAT does. If you use DNAT in LOCAL_OUT, a SNAT
mapping is also set up for LOCAL_IN. The socket lookup is performed
later in the individual protocols, so it will use the rewritten
source address.
