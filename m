From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Re: [RFC] iptables namespaces
Date: Fri, 7 Sep 2007 20:46:42 +0200
Message-ID: <20070907184642.GA4728@outback.rfc2324.org>
References: <20070907180204.GA460@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20070907180204.GA460@ekonomika.be>
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

Am Friday, den  7 September hub Steven Van Acker folgendes in die Tasten:

Hi!

> I've been thinking about some kind of namespaces in iptables where one can 
> switch from one set of rules to another set of rules by flicking a switch.

> In our current setup, we have about 7000 firewall rules. Every time the 
> rules get updated, all of them are removed and uploaded again by a script.
> Loading all these rules takes a while (let's say a minute, I'm not sure).

> The result is that for 1 minute, some traffic can get through the firewall rules
> while other can not. We have had problems with spam getting through to 
> mailservers behind the firewall, because not all firewall rules were loaded.

That problem can be solved.
man iptables-restore

> Using namespaces would make it possible to load all rules in another namespace
> and when all rules are loaded, a switch can be toggled to switch over to the new
> ruleset atomically.

That would be most probably nothing different to a iptables-restore.
If you want to emulate that, load your 7000 iptables rules on a
temp-machine, use iptables-save, copy the file to your firewalls and run
iptables-restore

Ciao
max
-- 
	Follow the white penguin.
