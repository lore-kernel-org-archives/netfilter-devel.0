From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables as a state machine
Date: Fri, 1 Oct 2004 13:12:36 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0410011244480.12730@filer.marasystems.com>
References: <20040930193955.6fa24afc.davem@davemloft.net>
	<61687.63.170.215.71.1096602469.squirrel@www.osdl.org>
	<20040930210127.0ac9623c.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, shemminger@osdl.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20040930210127.0ac9623c.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 30 Sep 2004, David S. Miller wrote:

> How prefix expansion works is basically like the following.
> Say you had a rule which matches on address "10.0.0.0/24"
> Prefix expansion would duplicate this rule 256 times, one
> for every address in that prefix'd range.
>
> 	10.0.0.1
> 	10.0.0.2
> 	...
> 	10.0.0.255

this is not what hipac does.

hipac works on ranges, not prefixes. In the decisiontree it collects the 
list or unique ranges for the active rules of the current dimention

By example:

If the ruleset contains the following destinations, in priority by the 
order listed:

    10.0.0.45-10.0.0.64
    10.0.0.0/24
    10.0.0.87

then the decision tree contains

    10.0.0.0-10.0.0.44
    10.0.0.45-10.0.0.64
    10.0.0.65-10.0.0.255

    (10.0.0.87 is hided by the /24, and does not exists in the hipac tree)

if 10.0.0.87 is moved up one line to unhide it, or there is matches in 
later dimentions making this range active then the tree will contain

    10.0.0.0-10.0.0.44
    10.0.0.35-10.0.0.64
    10.0.0.65-10.0.0.86
    10.0.0.87
    10.0.0.88-10.0.0.255



It is true that the current tree algorith is a bit memory hungry due to a 
lot of information being duplicated when there partially overlapping or 
partly identical rules, but Michael is working on a new generation where 
the tree is optimal with no duplicated information. This complication in 
memory usage is from the lookup being applied in multiple dimenstions 
(destination, source, protocol, ports, ...).

Example:

   iptables -A FORWARD -d 192.168.1.54 -s 10.0.0.0/24 -j LOG
   iptables -A FORWARD -d 192.168.1.54 -s 10.0.0.0/24 -j ACCEPT
   iptables -A FORWARD -d 192.168.1.87 -s 10.0.0.0/24 -j LOG
   iptables -A FORWARD -d 192.168.1.87 -s 10.0.0.0/24 -j ACCEPT
   iptables -A FORWARD -d 192.168.1.0/24 -s 10.0.0.0/24 -j REJECT

In the current algorithm this becomes


Destination tree (ROOT):

   192.168.1.0  - 192.168.1.53  -> Source tree 1
   192.168.1.54                 -> Source tree 2
   192.168.1.55 - 192.168.86    -> Source tree 3
   192.168.1.87                 -> Source tree 4
   192.168.1.88 - 192.168.1.255 -> Source tree 5

Source tree 1:

   10.0.0.0-10.0.0.255  -j REJECT

Source tree 2:

   10.0.0.0-10.0.0.255  -j LOG, ACCEPT

Source tree 3:

   10.0.0.0-10.0.0.255  -j REJECT

Source tree 4:

   10.0.0.0-10.0.0.255  -j LOG, ACCEPT

Source tree 5:

   10.0.0.0-10.0.0.255  -j REJECT


while in the new algorithm all the identical subtrees will be eleminated, 
resulting in a hipac ruleset which looks like


Destination tree (ROOT):

   192.168.1.0  - 192.168.1.53  -> Source tree 1
   192.168.1.54                 -> Source tree 2
   192.168.1.55 - 192.168.86    -> Source tree 1
   192.168.1.87                 -> Source tree 2
   192.168.1.88 - 192.168.1.255 -> Source tree 1

Source tree 1:

   10.0.0.0-10.0.0.255  -j REJECT

Source tree 2:

   10.0.0.0-10.0.0.255  -j LOG, ACCEPT



and all this while still allowing for very efficient insert/delete 
operations.



what the iptables core is solving is the range location problem of a 
multidimensional lookup (destination, source, ports, protocols etc...). 
The user entered ruleset information is backward compatible with iptables 
for convenience, but already allows you to specify ranges rather than 
prefixes and it is not unlikely it will become even more expressive in the 
future to allow for much leaner ruleset specifications.

Regards
Henrik
