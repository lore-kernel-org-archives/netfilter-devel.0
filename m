From: Stephen Clark <stephen.clark@earthlink.net>
Subject: Re: view nat mappings
Date: Fri, 03 Feb 2006 13:04:12 -0500
Message-ID: <43E39B1C.7090703@earthlink.net>
References: <43E21484.3060400@earthlink.net> <43E385BC.8010807@eurodev.net>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: sclark46@earthlink.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <43E385BC.8010807@eurodev.net>
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

Pablo Neira Ayuso wrote:

>Stephen Clark wrote:
>  
>
>>Does iptables have the capability to list out the actual nat
>>mappings/translations,
>>not just the rules that are currently active -
>>similar to the way FreeBSD's ipfilter/ipnat does?
>>    
>>
>
>So, if I understood well, you want to get only current nat'ted
>connections, right?
>
>If so, this is fairly easy to implement in the conntrack tool. Something
>like `conntrack -L nat` to show all current nat'ed connections. Is this
>really of interest for everyone?
>
>  
>
Actually this is on an embedded system running uClinux 2.4.6, an 
ActionTec DualPC Modem.
I am trying to use it as backup for ipsec traffic. Everything works 
great until we have an interruption - like the phone connection drops 
the vpn won't get reestablished. But when we
use an Apple Airport Extreme Base Station - the vpn get reestablished 
with no problem. So it
seems ther is some state in the ActionTec modem/router - it is 
performing masquerading - that keep the vpn from coming up. IT is really 
strange because we get SA's (isakmp traffic) on both sides, but esp 
traffic never gets across.

Steve
traffic doesn't
