From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tc filtering vs iptables
Date: Sat, 28 Aug 2004 02:00:44 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408280154210.10193@filer.marasystems.com>
References: <1093614389.1068.20.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408271751360.32691@filer.marasystems.com>
	<1093632324.14188.2.camel@jzny.localdomain>
	<20040827201137.GB9274@ti64.telemetry-investments.com>
	<1093638474.14190.29.camel@jzny.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jamal <hadi@cyberus.ca>
In-Reply-To: <1093638474.14190.29.camel@jzny.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 27 Aug 2004, jamal wrote:

> Can you emulate a patricia tree out of chains?

Yes, sort of.

If you like chains are just nodes with a list of branches or terminal 
leaves (the rules).

What you can't have in iptables is the prefix compression used in 
patricia, or at least not to the same level. You can still compress if 
your rules are based on multiple "dimensions" of the packet address space 
(i.e. source, destination, port).

But seriously speaking, if you are looking into ruleset requiring this 
amount of address information I stronly suspect ippool (or it's successor 
ipset) is the best tool for the job, allowing you to quickly group similar 
things together.  Only if you need to assign unique classification to each 
individual flow do you need a rule for each. But then again I do not have 
the full picture of the type of packet classification you are trying to 
accomplish.

Regards
Henrik
