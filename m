From: Paolo Rossi <paolo_76@inwind.it>
Subject: Re: SNAT multicast traffic
Date: Tue, 08 Feb 2005 14:52:05 +0100
Message-ID: <4208C405.9020907@inwind.it>
References: <420882B9.3050108@inwind.it>
	<20050208144638.GQ6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050208144638.GQ6878@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>On Tue, Feb 08, 2005 at 10:13:29AM +0100, Paolo Rossi wrote:
>  
>
>>Hi all,
>>
>>
>>I have a trouble with netfilter. I need to perform a SNAT to outgoing 
>>multicast packet. Multicast packet come from private network and i can't 
>>annunce this private network in my routing domain. Becauseour routers 
>>manage multicast traffic with PIM-SM protocol and PIM perform RPF (reverse 
>>path forwarding), the clients can't see the multicast traffic. I've read 
>>that netfilter don't support multicast SNAT, why?
>>    
>>
>
>netfilter/iptables doesn't implement multicast NAT at all.  this is due
>to it's strictly stateful fully-symmetric implementation, which
>obviously doesn't fit the multicast paradigm (where 'reply' packets of a
>multicast 'connection' don't have the inverted
>sourceip<->destinationip).
>
>  
>
Thank you very much Harald.
Is it possible to perform stateless nat in Linux ?
