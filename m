From: Peter Stamfest <peter@stamfest.at>
Subject: Accessing iptables from within an application...
Date: Sat, 15 Mar 2003 22:05:51 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0303152146460.20889-100000@peter.stamf.pr.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello, 

First: Maybe this has been done before, if so: all the better, please tell 
me.

The Project: I am writing an SNMP module for net-snmp to access the 
counters of iptables rules. This is for monitoring and accounting with 
tools like mrtg and my upcoming tool I plan to release shortly. 

In order for this to work, I want to provide "meta" information about the
rules along with the counters in order to be able to use SNMP lookups to
find the correct counter SNMP variable (much like looking up the interface
ID [=a potentially changing number] used to poll for interface statistics
from the interface IP address [=a much more stable information for a given
interface]). This already works quite well, I simply took the libiptc
library out of the iptables distribution to use it to access the iptables
information.

$ snmpwalk -v2c -m all -c $COMMUNITY localhost .1.3.6.1.4.1.12806.6.1.1

IPTABLES-MIB::tableIndex.0 = INTEGER: 0
IPTABLES-MIB::tableIndex.1 = INTEGER: 1
IPTABLES-MIB::tableName.0 = STRING: "nat"
IPTABLES-MIB::tableName.1 = STRING: "filter"

[..snip..]

IPTABLES-MIB::chainRule.0.2.0 = STRING: ";j=ACCEPT"
IPTABLES-MIB::chainRule.1.0.0 = STRING: ";j=ACCEPT"
IPTABLES-MIB::chainRule.1.0.1 = STRING: ";s=192.168.3.0/24;j=ACCEPT"
IPTABLES-MIB::chainRule.1.0.2 = STRING: ";p=6;s=192.168.3.0/24;j=ACCEPT"


Where the IPTABLES-MIB is an experimental private MIB. The chainRule 
variables are thought to provide for a packet representation of the filter 
rule. I plan to implement other variables to access specific information 
later. The indices following the "chainRule" are: A table id (eg. 
"filter"), a chain ID (eg. "OUTPUT") and a rule ID (eg. the second rule in 
the chain).

The problem now is quite obvious: How to access module specific 
iptables extension information ("-m")? I stumbled across the "save" method 
in the iptables modules, but this prints to stdout. Is there any similar 
mechanism to get the same information in some other form? Even a "sprintf" 
based solution would be OK in addition to the "printf" version to have the 
info in a character buffer, ready to send via SNMP....

If anything of this makes any sense to you: Is there any such interface 
that I simply missed?

And another question: When using the libiptc library, I need to call 
iptc_init(tablename). How can I free the data structure I obtain through 
this call when I no longer need it? I guess a simple "free" won't do the 
trick?

thanks in advance

peter
