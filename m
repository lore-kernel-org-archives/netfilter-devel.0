From: Wayne Schroeder <raz@positivenetworks.net>
Subject: Re: What basic sanity checking on packet headers is done
Date: Fri, 29 Sep 2006 11:59:34 -0500
Message-ID: <451D50F6.5020709@positivenetworks.net>
References: <451D47E5.7000108@positivenetworks.net>
	<451D4EB9.2020905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <451D4EB9.2020905@trash.net>
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

Sounds like somone as root on the local machine could make packets that
would pop the kernel if the conditions were right, but everything else,
specifically remote traffic, will be safe to trust ihl and tot_len on?
If that's the case, then I'm in the clear.

Wayne


Patrick McHardy wrote:
> Wayne Schroeder wrote:
> 
>>I've written a new target module that uses the ip header fields of ihl
>>and tot_len for offsets into the packets.  How safe is the data in the
>>ip headers?  Is there sanity checking when the packet is received off
>>the wire... for instance -- is it safe to assume in the prerouting chain
>>of the mangle table that tot_len will not put me past the memory
>>allocated for the packet?  Same goes for ihl?
> 
> 
> Check out ip_rcv() in ip_input.c. ihl and tot_len are _usually_ valid
> within netfilter. The only exception is raw sockets, on the outgoing
> hooks the only guarantee is that ihl * 4 >= sizeof(struct iphdr) (
> only for ip_tables, see iptable_filter.c). We could consider providing
> stricter guarantees, I'm pretty sure some modules only perform
> insufficient checks.
> 
