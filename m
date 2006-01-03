From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack NAT problem w/ UDP
Date: Tue, 03 Jan 2006 13:18:12 +0100
Message-ID: <43BA6B84.3020509@trash.net>
References: <H0000067001795ab.1135782766.@MHS>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, bof@bof.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: chip@innovates.com
In-Reply-To: <H0000067001795ab.1135782766.@MHS>
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

chip@innovates.com wrote:
> The packet rewriting is not happening for the outgoing packets, 
> therefore the other end can never reply because it has a private IP 
> address being sent as the source address.  
> 
> The timeout issue has been thoroughly debunked by numerous people.  
> Asterisk sends a packet every 30 seconds to keep NAT connections alive.  
> 
> 
> The problem is definitely something getting lost in netfilter.  When the 
> problem occurs, DNS and other UDP traffic with different source ports 
> than destination ports are still correctly rewritten.  The last time the 
> problem occurred for me, I completely reload the all the tables and 
> tried using SNAT vs. MASQUERADE.  Nothing made any packets get rewritten 
> for Asterisk connections except rebooting the router.  Next time, I will 
> try unloading all the netfilter modules and reloading them before 
> rebooting.  
> 
> When this happens I don't have much time for debugging, because of the 
> urgency to get a production phone system back in service.  That is why 
> I'm asking what should I examine to find out where netfilter is missing 
> this connection?

You could monitor the conntrack events with the conntrack tool.
A table dump while the problem occurs might also help.
