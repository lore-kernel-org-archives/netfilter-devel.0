From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] comment match port to pom-ng
Date: Mon, 17 May 2004 23:30:44 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405172321180.27355-100000@filer.marasystems.com>
References: <Pine.LNX.4.33.0405172303140.30893-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Brad Fisher <brad@info-link.net>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0405172303140.30893-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 17 May 2004, Jozsef Kadlecsik wrote:

> If you generate your rules from some kind of policy by a meta-language,
> then if you want to add an additional rule permanently, then you add it
> both to the policy and the running kernel. If you don't want to add it
> permanently, then you don't add it to the policy. The same can be done
> when you work with a script. You write, that custom rules can be added
> to pre-defined chains, used as entry points just for custom rules. What
> can't I see properly in your case?

Some may find adding "comment" information to the rule rather than
creating a jump to a custom chain better documents the rule and makes
maintenance easier.

One extreme example is an automated tool running on a chain of rules which
MAY also contain rules of other source. By using the comment field the
application can differentiate between it's own rules and rules of other
source.  Yes, in most if not all cases the same can be done with a custom
chain and a jump, but if you need very many differentiations of rules then
this can result in a ridicoulus amount of custom chains with just one or
two rules in them..

In addition the comment can be used to identify the source for the rule
when there is multiple applications modifying the iptable.  Consider for
example a firewall consisting of both a static policy and dynamic rules
carefully weighted. The comment can then be used to indicate the source of
the rule (policy, dynamic action X, dynamic action Y etc..)

Another interesting application is when adding temporary rules outside of 
the permanent policy. By using a comment it is easy to give some form of 
indication why the rule is there and when it should be removed.

And as I said earlier it makes even more sense if the firewall policy is
maintained using iptables-save/restore such as is the case in several
distributions. The comment then automatically gets saved into the policy
by iptables-save and eleminates the need for the administrator to keep 
separate records of the firewall rules.

Regards
Henrik
