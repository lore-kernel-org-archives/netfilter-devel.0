From: Brad Fisher <brad@info-link.net>
Subject: Suggestion for RETURN target
Date: Tue, 02 Dec 2003 18:35:43 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCD2FDF.69796CD5@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Would it be possible to modify the RETURN target in such a way that it
could return to an arbitrary chain in the call stack instead of only to
the previous chain?  For example, something like:

    iptables -N chain2
    ... other rules for chain2 ...
    iptables -A chain2 -j RETURN --return-to 2

    iptables -N chain1
    iptables -A chain1 <matches> -j chain2
    iptables -A chain1 -j DROP

    iptables -A FORWARD -j chain1

In the above example, the DROP rule in chain1 would never get executed
when the chain2 rule matched since the RETURN target in chain2 would
"return-to" the 2nd to last chain in the call stack instead of the
calling chain.  Perhaps "return-to" isn't the best name...  Something
like "return-levels" or similar would work just as well for me.  The
current behavior would be maintained if the additional parameter was not
given.

If this isn't a possibility, then what about a way to attach a second
(or third, etc?) target to a rule?  The targets would execute in
sequence, with certain obvious ones such as ACCEPT/DROP/REJECT/etc
stopping target execution.  With this, I could write the example above
as follows:

    iptables -N chain2
    ... other rules for chain2 ...

    iptables -N chain1
    iptables -A chain1 <matches> -j chain2,RETURN
    iptables -A chain1 -j DROP

    iptables -A FORWARD -j chain1

Where the sequence "-j chain2,RETURN" means execute chain2, then if it
returns execute a RETURN to the previous chain.

Either of these two approaches would allow me to reduce my ruleset 1/2
the rules currently required.

Anyway, just thought I'd thow it out there to see what others think.

-Brad
