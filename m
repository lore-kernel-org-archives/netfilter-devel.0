From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Mon, 1 Jul 2002 11:47:09 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0207011037260.12444-100000@blackhole.kfki.hu>
References: <200206291236.36997@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200206291236.36997@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 29 Jun 2002, Henrik Nordstrom wrote:

[...]
> I proposed adding a new class of iptables things between matches and
> targets, being neither a match for filtering or a target that
> determines the ultimate fate of the packet. The names proposed for
> these in the discussion was modifiers or actions.

I believe we have four possibilities

- multiple targets

  It has been rejected several times with good reasons: too error-prone
  for the users and it would require heavy modifications both in the
  kernel and the userspace.

- a new class: actions

  With the new class, we would have to following skeleton of a rule:

	IP match data
	list of matches
	list of actions
	single target

  Using any action would make sense only when the target is ACCEPT and
  alike, so the actions function as 'always true' matches.

  One also has to note, that we have a nice, visible separation of matches
  and targets by name: matches are lowercased, while targets are
  uppercased. How could actions be fit into this scheme? How could one
  decide by glimpse that we are speaking about a match, action or
  target?

  [I'd name the new class as 'action' instead of 'modifier', because '-m'
  is reserverd but '-a' is not.]

- rewrite the IPT_CONTINUE targets as matches

  What would be solved by actions so nicely is biting here:
  order-dependecy. Users should keep in mind, that the rule of
  thumb is that 'always true' matches must come at the end of the rules.
  But one has to note that the 'match' instead of 'action' approach would
  lead a little bit more flexibility as well: actions have only effect
  when all matches are true in the rule. (What is drawback from one point
  of view, advantage from another one.)

  The cases, when we have match/target pairs (like 'mark/MARK, ecn/ECN,
  dscp/DSCP, etc) could be unified into single matches. (The 'recent'
  match is a really nice example for such a solution. It could have been
  introduced as a separated 'recent' match and a 'RECENT' target as well.)

- do nothing: the problem can always be solved by introducing custom
  chains :-)

> So the question to the Netfilter core team is if it would be OK to add
> a new option and "module class" to the userspace tools, and have the
> existing IPT_CONTINUE targets dual-register as both a target and a
> match. I can try to whip something together if this is seen as

In my opinion the match solution would be better, cleaner.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
