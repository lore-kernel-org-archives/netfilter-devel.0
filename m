From: don-nfil1@isis.cs3-inc.com (Don Cohen)
Subject: Re: Multiple Targets
Date: Sat, 19 Feb 2005 12:54:57 -0800
Message-ID: <16919.42913.822707.592416@isis.cs3-inc.com>
References: <200502191851.j1JIpOq22471@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200502191851.j1JIpOq22471@isis.cs3-inc.com>
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


 > Example (where n is the number of authorized macs):
 > iptables -N auth
 > iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:00 -j MARK
 > --set-mark 1
 > iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:00 -j RETURN
 > iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:01 -j MARK
 > --set-mark 2
 > iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:01 -j RETURN
 > ... n ...
 > iptables -A auth -i int+ -m mac --mac-source FF:FF:FF:FF:FF:FF -j MARK
 > --set-mark n
 > 
 > I had the idea of allowing multiple targets, as long as the targets
 > before the last were non-terminating. Following on my example above,
 > it would look something like this:

I think it would be better to focus on a better way of matching
large sets.  You currently have n x m rules for n addresses and
m targets.  Since n is much more likely to be large than m I
want to get rid of the factor if n rather than m, especially in
the run time.

The example above suggests a module that supports a hash table.  
You load the module, fill it with a large number of (in this case) 
mac addresses, and then in one rule match any mac address in that 
set.  This module could be parameterized by the size of the data 
you want to match.  You could use /proc files to read/write the 
table.  The iptables rule would then need some way to specify what 
to extract from the packet to match.  I imagine something like the 
u32 match where instead of comparing the extracted values with 
constants in the rule, these are just collected into a byte sequence 
which is then used as a hash key.

I think it would be useful to have such a module as a pure match, to
recognize members of a given set, but in the example above (which I
find rather odd), that saves nothing because every address has its own
mark, and I end up with one rule per mark.  In practice I think that
the number of marks is much less likely to be large than the number of
keys, but one could remove the factor of the number of marks by
generalizating the table to include a value for each key, where the
value is used to mark the packet.  

Another possibility, perhaps a third alternative version of the
module, would be replacing the hash table with a binary search, in
order to support ranges.

 > If the latter, how about having a match target instead that matches if 
 > the previous one matched?
 > 
 > i.e.
 > 
 > >iptables -A INPUT -p tcp --dport 53 -j LOG --log-prefix "foo: "
 > >iptables -A INPUT -p tcp --dport 53 -j MARK --set-mark 1
 > >iptables -A INPUT -p tcp --dport 53 -j ACCEPT
 > >  
 > >
 > would instead be written:
 > 
 > iptables -A INPUT -p tcp --dport 53 -j LOG --log-prefix "foo: "
 > iptables -A INPUT -m previous -j MARK --set-mark 1
 > iptables -A INPUT -m previous -j ACCEPT

How about just using the first rule to set the mark, and using 
the mark to trigger the rest?  I assume that matching the mark
is about as cheap as any match can be.
