From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Iptables Suggestions
Date: Sat, 29 Nov 2003 19:41:12 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311291936070.20615-100000@filer.marasystems.com>
References: <9D4BE90F90812E40B90C52C44D5F330901D76C48@sede-mail-01.net.in.iantel.com.uy>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Cremella, Gustavo" <gcremella@antel.com.uy>
In-Reply-To: <9D4BE90F90812E40B90C52C44D5F330901D76C48@sede-mail-01.net.in.iantel.com.uy>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 Nov 2003, Cremella, Gustavo wrote:

> If you need to rerun a script, usually (as seen in lots of examples) you have to flush all rules and start again from scratch. 

I would strongly advice to use iptables-restore if you need to make more 
than a single rule change. iptables-restore reads a complete ruleset and 
then atomically installs it into the kernel.

> You can remove a rule if you know exactly its order within a chain, but
> this may be impossible in a firewall that loads and unload some
> forwarding rules dinamically like those used on cybers when enabling o
> disabling a machine from conecting to the internet.

I would recommend having a database of who is allowed to access the 
internet and from this build the full ruleset to be installed with 
iptables-restore each time there is a change.

Alternatively, if it is simple "this IP address is now" allowed/not 
allowed operations then you can use ippools whichc allows you to keep a 
static ruleset and just modify which IP addresses are active in the 
ruleset.

> Syntax suggestion: iptables -AC FORWARD......., where AC is the command
> for Append Conditional if no existing rule also match that kind of
> packets in that chain and target.

Would be nice indeed, but does only solve a small subset of the bigger 
problem of how to adjust complex rulesets to changes in who should be 
allowed/denied..

Regards
Henrik
