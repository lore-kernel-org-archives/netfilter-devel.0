From: Mike Andersen <mike@src.no>
Subject: Re: Idea: Check session source and destination
Date: Mon, 26 Apr 2004 15:40:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <427EA2C2-9787-11D8-8B47-000A957FD99E@src.no>
References: <Pine.LNX.4.44.0404241042450.2578-100000@filer.marasystems.com>
Mime-Version: 1.0 (Apple Message framework v613)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0404241042450.2578-100000@filer.marasystems.com>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Apr 24, 2004, at 10:43, Henrik Nordstrom wrote:

> Already done. See the conntrack match.

Ah, I was not aware of that one.

>> My assumptions here is that the source address in the state table
>> _always_ is the one that initiates the session.
>
> Correct. Even on related connections (unless the related connections  
> goes
> to another IP on the initiator side but I know of no such protocols)

Hm.  I'm having some odd problems here.  I'll try to explain... Take a  
look at my last message:
http://article.gmane.org/gmane.comp.security.firewalls.netfilter.devel/ 
6417 for more information about the scenario I'm working on.

I'm here trying to use netfilter to filter out which sessions the  
packet sniffer should be allowed to see.  The state table is being  
built independently of the rules configured in netfilter. Here is an  
example of a rule I use:

iptables -A FORWARD -m conntrack --ctorigdst <int_ip> -j ACCEPT
iptables -A FORWARD -j DROP

The way I understand this, this rule should pass through all traffic  
from sessions initiated against my internal IP (here: int_ip).  What  
really happens in my test environment is:

Sessions started against int_ip: All traffic is seen, as intended.
Sessions started from int_ip: The SYN packet is not mirrored to the  
packet sniffer, but the rest of that session is mirrored -- everything  
from the SYN-ACK to the end of the session.

I then look more closely at the state table (/proc/net/ip_conntrack)  
and see that there are two sets of source definition, and two sets for  
the destination:

tcp 6 <sec> ESTABLISHED src=<external ip> dst=<internal ip> sport=1367  
dport=80 src=<internal ip> dst=<external ip> sport=80 dport=1367 use=1

The direction of the second pair of src/dst addresses, are the opposite  
of the first pair.  Which pair is the conntrack code checking?

Any idea of why the "-m conntrack --ctorigdst <int_ip>" also passes  
through traffic where int_ip is the source of the session?

I'm using the version of netfilter that are included in the linux  
2.4.25 source code, which the patches from  
http://www.sentryfirewall.com/docs.html (also using the .config file  
from that project to compile the kernel). In addition to that, I've  
changed the bridge code according to the message here:
http://article.gmane.org/gmane.linux.network.bridge/1603

PS, this discussion should probably move from the developer list to the  
general netfilter list?

mike
-- 
"It is a lesson which all history teaches wise men, to put trust in
  ideas, and not in circumstances."            --Ralph Waldo Emerson
