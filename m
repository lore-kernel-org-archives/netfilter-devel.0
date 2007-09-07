From: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Subject: [RFC] iptables namespaces
Date: Fri, 7 Sep 2007 18:02:05 +0000
Message-ID: <20070907180204.GA460@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi again,

I've been thinking about some kind of namespaces in iptables where one can 
switch from one set of rules to another set of rules by flicking a switch.

In our current setup, we have about 7000 firewall rules. Every time the 
rules get updated, all of them are removed and uploaded again by a script.
Loading all these rules takes a while (let's say a minute, I'm not sure).

The result is that for 1 minute, some traffic can get through the firewall rules
while other can not. We have had problems with spam getting through to 
mailservers behind the firewall, because not all firewall rules were loaded.

Using namespaces would make it possible to load all rules in another namespace
and when all rules are loaded, a switch can be toggled to switch over to the new
ruleset atomically.

As far as I know, this is not possible with the regular tools at the moment.
Every time a rule gets added, the old rules are fetched from the kernel, the new
rule is added and the entire resulting new ruleset is uploaded to kernelspace 
again. But it's not possible to collect all 7000 rules in userspace only, using 
the iptables command, and then sending them all to userspace in one big batch.

I can see 2 ways that this can work:

 * By providing namespaces in the kernel, one can easily select a namespace with
   e.g. an ioctl and then upload rules to that namespace using iptables.
 * By providing a "staging area" in userspace to collect the entire ruleset 
   before sending the batch to kernelspace.

Assuming that something like this does not yet exist, which approach would be 
best ?

kind regards,
-- Steven
