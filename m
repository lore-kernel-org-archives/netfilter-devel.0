From: Martijn Lievaart <m@rtij.nl>
Subject: Re: LAND check: 2.4.20
Date: Wed, 16 Mar 2005 09:44:00 +0100
Message-ID: <4237F1D0.1020406@rtij.nl>
References: <BB6D74C75CC76A419B6D6FA7C38317B26A26DE@sinett-sbs.SiNett.LAN>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Vishwas Manral <Vishwas@sinett.com>
In-Reply-To: <BB6D74C75CC76A419B6D6FA7C38317B26A26DE@sinett-sbs.SiNett.LAN>
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

Vishwas Manral wrote:

>Hi Cedric/ Martin,
>
>Thanks for the reply. There are a few things you may be missing:-
>
>1. They cannot be in the rule set, unless we can put a rule which says for any Source-IP/ Port if destination will be the same value then drop. You cannot put the value of every possible IP/port in your rule set. Besides as you yourself mentioned the solution you state it may not work for all scenarios.
>  
>

Yes they can. You don't need a rule that syas srcip==dstip. If eth0 is 
connected to 1.2.3.0/24, put in a rule that drops traffic from any other 
interface with source address 1.2.3.0/24. In practice this works in any 
scenario where it matters imo.

>2. The source and destination address may be routed, though the same. So from a machine X I could send a packet with source and Destination IP of Y.
>  
>

Yes, that is possible. However, do you want to catch LAND attacks on a 
machine that has such weird routing functionality? If this really 
bothers you, write a custom match, it should be trivial.

>3. I am not sure which routing code checks for Source IP Address? Can you point me to some code (destroy it as a packet with local IP as source must be received on loopback)?
>  
>

See Patricks reply.

>The solution as done by most firewalls is to add a simple check in the check_tcp and check_udp. I think we need to add this to the iptables code.
>  
>

If you really need this functionality, it is trivial to write a custom 
match for it. If case 2 above is a reality for you, you need the 
flexibility of a custom match anyhow, as you cannot solve the problem 
generically in that case.

M4
