From: Patrick Schaaf <bof@bof.de>
Subject: Re: Bug#150467: user-defined chains vs. iptables module names
Date: Fri, 21 Jun 2002 10:10:55 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020621101055.E5183@oknodo.bof.de>
References: <20020620145619.GA1404@mail.nontoxic.org> <Pine.LNX.4.33.0206210940180.30045-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Laurence J. Lane" <ljlane@nontoxic.org>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0206210940180.30045-100000@blackhole.kfki.hu>; from kadlec@blackhole.kfki.hu on Fri, Jun 21, 2002 at 09:47:44AM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> The built-in chain and target names are all fully capitalized.
> What about the simple restriction that user-defined chain name cannot be a
> string consisting of capitalized letters only.

This is again breaking backwards compatibility. For example, most of my
rulesets contain two chains, named "RD" and "LRD". The first does the
"REJECT with limit, then DROP" stance, and the second puts a "LOG with
limit" in front of that. As both chains are "designed" to be used with
the same ease as REJECT or DROP, the "ALL CAPS" naming makes eminent
sense to me.

Let me make a different proposal, providing backward compatibility while
giving active control over the ambiguity:

- permit the definition of user defined chains having the same name as
  a possible target. This is now the case by chance, depending on whether
  an extension module is loaded, or not. My proposal is to permit it
  in all cases.
- when a user defined chain with the same name as a builtin target gets
  created, make all references to that target now refer to the new user-defined
  chain. This is the radical step, I think. If I define a chain named "LOG",
  all my logging targets would now refer to it.
- provide special syntax to call builtin targets, only. This may be a new
  command line option, or it may be as simple as putting "+" in front of
  the target name.

Here's an example of what I mean:

iptables -A INPUT bla bla bla -j LOG
...
iptables -N LOG
iptables -A LOG -m limit --limit 1/s -j +LOG --log-prefix "FILTER: "

After that sequence, the INPUT chain LOG would jump to the new LOG chain,
and the "+LOG" there would call the real builtin target.

The only drawback I can see now, is that builtin targets take arguments,
while user defined chains don't. Anyway, what do you all think of the
above general proposal?

best regards
  Patrick
