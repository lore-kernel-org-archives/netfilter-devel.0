From: Brad Fisher <brad@info-link.net>
Subject: Re: [PATCH] comment match port to pom-ng
Date: Mon, 17 May 2004 17:36:40 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A93E78.3F76FA26@info-link.net>
References: <Pine.LNX.4.44.0405172321180.27355-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



> On Mon, 17 May 2004, Jozsef Kadlecsik wrote:
>
> > If you generate your rules from some kind of policy by a meta-language,
> > then if you want to add an additional rule permanently, then you add it
> > both to the policy and the running kernel. If you don't want to add it
> > permanently, then you don't add it to the policy. The same can be done
> > when you work with a script. You write, that custom rules can be added
> > to pre-defined chains, used as entry points just for custom rules. What
> > can't I see properly in your case?

Basically, this sounds like there is some sort of intermediate storage of the
rule structure going on beyond iptables/netfilter.

Whenever a rule is changed, the meta-language would need to be updated to
reflect that change.  For example, when a rule is added manually via the
iptables command the meta-language may need to be updated to reflect new rule
positions.  I see no good/easy way to enforce this.  Without enforcement, how
can you be sure a comment attached to a rule via your meta-language accurately
represents the current state of the ruleset?  In fact, how can you guarantee
that the rules represented by your meta-language accurately represent the
current state of the ruleset?  With the comment match, you can be sure since
they are a part of the rule itself.

My scripts do not rebuild the entire ruleset, nor do they assume that they are
in full control of the ruleset.  They try to be as non-invasive as possible,
and use the comment match to try to enforce that by attaching comments with
specific and easy to recognize patterns to any rules created in built-in
chains.  Only rules with comments matching those patterns will be modified
later.

> Henrik Nordstrom wrote:

> Some may find adding "comment" information to the rule rather than
> creating a jump to a custom chain better documents the rule and makes
> maintenance easier.
>
> One extreme example is an automated tool running on a chain of rules which
> MAY also contain rules of other source. By using the comment field the
> application can differentiate between it's own rules and rules of other

... SNIP ...

> distributions. The comment then automatically gets saved into the policy
> by iptables-save and eleminates the need for the administrator to keep
> separate records of the firewall rules.
>
> Regards
> Henrik

I couldn't have said it any better.  I had a big long reply typed up and
decided to trash it after Henrik sent this :)

-Brad Fisher
