From: Patrick Schaaf <bof@bof.de>
Subject: Re: /etc/sysconfig/iptables format
Date: Sun, 24 Nov 2002 12:52:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021124115252.GD14672@oknodo.bof.de>
References: <Pine.LNX.4.44.0211200005530.5235-100000@azalea.cs.jmu.edu> <20021124104018.GC14672@oknodo.bof.de> <200211241328.57401.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Content-Disposition: inline
In-Reply-To: <200211241328.57401.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Bart,

> I'd like your opinion about the way ebtables makes atomically writing a 
> complete table to the kernel, possible.
[description of "reference file manipulation" approach to construct tables]

I like the scheme! May I have it for iptables, too, please?

Why do I like it? Using the reference file, permits test-construction
of an arbitrary rule set, with full rule consistency / error checking,
and inspection of the result, without modifying the runtime rule set
in any way. That's a great help when extending / modifying rule sets.
With the current iptables, about the only sane alternative is to
carefully construct a user mode linux instance mirroring your real
system, and testing table construction there. The idea of applying
all changes (optionally) to a reference file, saves big effort here.

Part of why I like this, is the possibility to run the ruleset
construction under an arbitrary uid. Only the final commit needs
to be done as root. When your construction scripts become large
that may be a great option, I think.

I have a small proposal to augment the idea: as an alternative to
specifying the reference file on the command line, could you define
a "standard environment variable" which, when set, gives the name
of the reference file to use? That way, one could run "rule set
construction scripts" completely unchanged, i.e. without fiddling
with the commandline of all the ??tables-commands in the scripts.
Just give something different in the environment before calling
the initial construction script.

> One could say the file being binary is a problem.

I don't think so. Having it binary, provides a rather strong hint that
nothing but the delivered tools (ebtables, in your case) are supposed
to understand the format. Doesn't raise futile expectations that way.

best regards
  Patrick
