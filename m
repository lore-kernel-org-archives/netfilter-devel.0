From: Michel Banguerski <Michel.Banguerski@laposte.net>
Subject: Re: Syncookie firewall
Date: Fri, 07 Jun 2002 11:21:40 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D007B24.9010804@laposte.net>
References: <20020606020322.05BF64258@lists.samba.org> <15615.36281.187120.257236@isis.cs3-inc.com> <200206061932.04510.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
[...]

>What worries me is
>
>  * Window scaling
>  * Timestamp
>  * ECN
>
>and a number of other end-to-end TCP options that depend on correct 
>negotiation during SYN.
>
>Sure, window scaling and ECN can be set by configuration if You know Your 
>server, but there is no good way to deal with the timestamp option short of 
>forcibly filter it out entirely from the TCP stream
>

I agree that this is far from being trivial. And in fact, I'm almost interested inprotecting servers  known to me. That's why it seems mandatory to me to use a mach/target approach that allows one to define a fine graned policy about 
SynCooking, but this approach also allows to  implement a fallback policy: if
You don't know how to handle a particular TCP option, You pass the connection to 
the transparent proxying daemon (then You will need to stick with it, but CONNMARK 
will do the job ;o).

Thus hardconding tcp options in the ruleset seems aceptable to me.
 
Additionally it may be possible to have some autolearning behaviour 
using an
approach similar to "recent" match module: You start with no SynCookies, 
but
when You see a SYN-ACK packet from an inside machine You  add it to a 
list of
hosts with known TCP capabilities. The drawback of this approach is when You
have NAT inside Your own network: the same inside address seen by Your FW
may show different behaviours depending on who is behind, once agan, for now
I cant see other solutions than to hardcode in Your rulset the fact that we
dont want learn about this address.

In fact we can combine fallback/autolearn approaches: The daemon that 
 relays
connections unhandled by SynCookie, can BTW track servers capabilities and
install appropriate rules, this would avoid the complexity of automodifying
ruleset.


The timestamp case: I must confess, I'm not sure to fully understand how it
works, but it seems to me that the important decision to take at SYN packet
reception is to agree ot not on timestamping. Would it be really 
harmfull if
the first timestamp is not accurate (if You answer to the timestamp from 
the
firewall the RTT value calculated by the peer will be shortened be the RTT
inside your private net with is commonly short) ? If we can accept that, 
then
let's just do like for other options: setup rules where you accept 
timestamp
for particular hosts and reject for the rest.

Well, all this works if you protect your inside network from outside 
attacks,
but protecting outside from inside is way more difficult because you can't
gather and keep information about all servers that your users will 
potentially
connect to. But precisely because you better control on inside, may be 
outgoing
SynCookies are not such important: because it's easier to avoid 
spooffing on
your corporate network, throttling outgoing SYNs may be suffisent...


What are other TCP options that You think of ?

Regards
Michel


BTW: I'm not 100% sure but it seems to me that at least inversion 4.1
Checkpoint FW1 was rejecting by default packets with *ANY* TCP
option , and people were "happy" with that  :-)
(of course vendors lasyness is ont a good reason for doing bad design)
