From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Wed, 17 Mar 2004 18:59:43 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079567983.2115.10.camel@localhost>
References: <Pine.LNX.4.44.0403180022440.15641-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Victor Julien <victor@nk.nl>,
   Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403180022440.15641-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-03-17 at 18:45, Henrik Nordstrom wrote:
> On Wed, 17 Mar 2004, Victor Julien wrote:
> 
> > This might be a big improvement, but it leaves me with one possible 
> > problem. When adding and removing rules on-the-fly i can't use this 
> > method, right?
> 
> You can. There is a --noflush option to iptables-restore to not flush the
> existing rules, allowing you to use iptables-restore to add/modify/delete
> existing rules without having to specify the whole ruleset.
> 
> > Wouldn't it be nice if there was an c function which i could call, which 
> > would do all the checking and other stuff the commandline iptables does, 
> >   but, because its a c-function, way faster? Would it be easy (or even 
> > possible) to implement such a function?
> 
> Such C function would only be marginally faster than having a pipe to 
> iptables-restore.
> 
> iptables-restore has the exact same capabilities as iptables, only 
> difference is that iptables-restore is batch oriented compiling all your 
> changes and then uploading them into the kernel in one single call while 
> iptables makes one modification to the table per call.
> 
> iptables-restore accepts the exact same set of commands as iptables with 
> only some minor syntactical sugar differences
> 
> Syntax for iptables-restore input is
> 
> *tablename
> start working on rules in table "tablename". Equivalent to the -t option 
> to iptables.
> 
> :chainname policy
> specifies the default policy for chain "chainname". Equivalent to the 
> iptables -P command. Probably also works just fine to use the -P command 
> but I have not tried.
> 
> COMMIT
> Uploads the current table (specified by *tablename) to the kernel.
> 
> #....
> Input lines starting with # are assumed to be comments and are ignored
> 
> Any other lines are assumed to be iptables commands per the iptables 
> syntax specification.
> 
> iptables commands may be prefixed by [packetcnt:bytecnt] which gets
> automatically translated into --set-counters packetcnt bytecnt before the
> command is executed within iptables-restore. The two syntaxes are
> equivalent.
> 
> 
> Don't be fooled by the fact that iptables-save only uses the -A command or
> by the name iptables-restore. What iptables-restore is is a batch version
> of iptables with all the capabilities of iptables, not just a tool to
> restore complete tables saved by iptables-save.
> 
> Regards
> Henrik
I found that there were a few other differences.  As far as I can tell,
you can only have one table section per file, in other words if I have a
file such as
*nat
some rules
COMMIT
*filter
some more rules
COMMIT
*nat
some more rules
COMMIT

only the first set of NAT rules commits.  I also found that I needed to
use an explicit declaration of implicit matches, e.g.,
*filter
-A FORWARD -p 6 --dport 80 -j ACCEPT - does not work
-A FORWARD -p 6 -m tcp --dport 80 -j ACCEPT - does work
COMMIT

I did find that the performance difference for even small rule sets was
noticeable and, for large rule sets, it was absolutely stunning - John

-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
