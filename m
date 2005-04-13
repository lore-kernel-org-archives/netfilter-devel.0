From: Wang Jian <lark@linux.net.cn>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 08:48:25 +0800
Message-ID: <20050413084249.0309.LARK@linux.net.cn>
References: <20050407064323.GE20287@oknodo.bof.de>
	<425A47BD.9070508@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Ben La Monica <ben.lamonica@gmail.com>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <425A47BD.9070508@outerspace.dyndns.org>
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

Hi Jonas Berlin,

The problem is how to handle rule deletion, for example,

  iptables -A INPUT -p tcp --dport 137 -j LOG --log-prefix windows
  iptables --previous -j DROP

When the first rule is deleted, then the second --previous is gone?


On Mon, 11 Apr 2005 09:47:41 +0000, Jonas Berlin <xkr47@outerspace.dyndns.org> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Quoting Patrick Schaaf on 2005-04-07 06:43 UTC:
> 
> | Hmm, regarding --previous... Do we have two bits spare in the
> | general rule structure, which could indicate 'match just like
> | the previous match did', and 'match exactly if the previous
> | match did NOT match'?
> 
> Yes. IPT_F_MASK has many spare bits, and IPT_INV_MASK has exactly one
> bit left (same for ipv6).
> 
> | It we do have such bits spare, a general --previous-matched
> | and --previous-failed syntax might be easier than a new match
> | with signature change or percpu variables: all decision logic
> | stays properly localized in the table scanning main loop.
> 
> This is my implementation exactly. I also believe this does not break
> binary compatibility; it just extends the use of the bitmasks, and
> "older" iptables clients will just never set the bits in question - and
> in the other way around when the iptables binary supports --previous but
> the kernel doesnt no problems occur unless the user tries to use --previous.
> 
> | BTW, it just occurred to be that --previous-failed, a logical
> | consequence of the --previous idea :), is a nice thing to
> | have by itself: it permits proper if/then/else semantics
> | for nonterminating targets!
> 
> Naturally, I thought of this too.. :)
> 
> | iptables -A xxx --previous-failed -j LOG --log-prefix "NOT-thisandthat: "
> 
> actually..
> 
> iptables -A xxx ! --previous -j LOG ...
> 
> There's one slight peculiarity with the current implementation.. if one
> wants to use a target that works only for some specific protocol, say
> TARPIT, one needs to:
> 
> iptables -A INPUT --previous -p tcp -j TARPIT
> 
> .. I haven't yet investigated if it would be possible to inherit the
> protocol nicely..
> 
> I include only the kernel part of the patch for now so you can study and
> complain about it :) I have some pending fixes for ip6tables that I want
> to go in first before posting the iptables patch, which is trivial anyway..
> 
> I'm sorry for the long delay.. as you see from the patch it was done
> more than three weeks ago.. :/ Otoh I tested it properly only last week.
> 
> - ----
> 
> I have also been thinking a bit about the original suggestion by Ben La
> Monica in the thread "Multiple Targets" to allow multiple targets:
> 
> Quoting Patrick Schaaf on 2005-02-19 08:28 UTC:
> 
> |> iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:00 -j
> |> MARK,RETURN --set-mark 1
> |> iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:01 -j
> |> MARK,RETURN --set-mark 2
> |
> | Problem: target options. How would the commandline parser see that
> | --set-mark belongs to MARK, and --log-prefix belongs to LOG? What
> | about the hypothetical case of several targets having target options
> | with identical names?
> 
> How about:
> 
> iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:00 \
> ~  -j MARK --set-mark 1 -j RETURN
> 
> and further:
> 
> iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:00 \
> ~  -j MARK --set-mark 1 -j LOG --log-prefix "mark!" -j RETURN
> 
> This way the options would be clearly grouped and easily parsable. The
> amount of targets (in the structs passed from/to userspace and used in
> the kernel) could probably be made flexible, just like the matches are.
> Even with the current iptables the target can be omitted, so it actually
> already has some flexibility :)
> 
> This all would possibly, although not necessarily break binary
> compatibility with the kernel. I am not familiar with the extendability
> of the userspace "api"..
> 
> Even if it would break binary compatibility, I see how it could be
> useful for users with large rulesets, since this could possibly halve
> the amount of rules needed, and I think at that point these users might
> be willing to recompile iptables to get that benefit, and of course
> others who just like the comfort :)
> 
> - --
> - - xkr47
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.1 (GNU/Linux)
> 
> iD8DBQFCWke2xyF48ZTvn+4RArC0AJ9pFgdW+kfBSstLRjumo2fTGvuTkwCeLf3M
> YCvA+Z/rjQkWAJdlf2HgFRk=
> =3twV
> -----END PGP SIGNATURE-----



-- 
  lark
