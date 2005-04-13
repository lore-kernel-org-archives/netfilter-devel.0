From: Patrick Schaaf <bof@bof.de>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 08:45:50 +0200
Message-ID: <20050413064550.GA16534@oknodo.bof.de>
References: <20050407064323.GE20287@oknodo.bof.de>
	<425A47BD.9070508@outerspace.dyndns.org>
	<20050413084249.0309.LARK@linux.net.cn>
	<425C6D58.3090002@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Content-Disposition: inline
In-Reply-To: <425C6D58.3090002@outerspace.dyndns.org>
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

> Quoting Wang Jian on 2005-04-13 00:48 UTC:
> > The problem is how to handle rule deletion, for example,
> > 
> >   iptables -A INPUT -p tcp --dport 137 -j LOG --log-prefix windows
> >   iptables --previous -j DROP
> > 
> > When the first rule is deleted, then the second --previous is gone?
> 
> Unfortunately not. It gets combined with the rule before that. Or if
> there was no rule before that, it never matches.
> 
> If the official netfilter guys think that --previous rules should be
> deleted also when parent is gone, I can look at how to implemenent that
> at some point.

Not that I'm an official netfilter guy, but I think that there should
not be any such automation. It will be up to the admin, and a delicate
task, to _write_ rules using --previous - why wouldn't one also trust the
admin to get deletion right, then?

In a programming language, even an IDE (although I don't use them),
I wouldn't expect the body of an if(){} statement to go away
automatically when I delete the if condition itself. Why should
it be different, here?

Finally, it could even be the desire of the admin to keep the --previous
rule, and have it match the rule before the deleted rule. The hypothetic
double-rule-deletion would make that impossible.

best regards
  Patrick
