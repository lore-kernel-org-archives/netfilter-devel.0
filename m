From: Patrick Schaaf <bof@bof.de>
Subject: Re: urgent help on libiptc
Date: Mon, 10 Mar 2003 18:42:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030310174217.GA8066@oknodo.bof.de>
References: <20030309190618.11970.qmail@web41007.mail.yahoo.com> <20030309192348.GA7177@oknodo.bof.de> <1436569576.20030310182144@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: DarKRaveR <DarKRaveR@habitat-b.de>
Content-Disposition: inline
In-Reply-To: <1436569576.20030310182144@habitat-b.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Humm, that doesn't sound too good.

Too bad.

> libiptc would be a great thing for directly manipulating rules. if one
> has to use the command line tool, there's an annoying problem: you
> would have to parse the output, which is not really a way I would love
> to go (I am facing the same problem here).

This is true. Note that iptables-save format is designed to be a bit more
sane to parse than 'iptables -L' output. Especially, there is already a
working parser, called iptables-restore. Hope this helps some.

> On the other hand, since
> the commandline tool always transfers all rules between kernel and
> userspace, it's awfully slow, if you have to update/modify approx 3000
> rules.

This will be exactly the same when you use libiptc - it is the
(admittedly broken) way the kernel/user interface works, now.
This is the main driver which pushes the rewrite that is currently
happening.

> The other question which remains then: Will the iptables commandline
> tool be stable in the sense of: will the output be the same and will
> the commandline switches stay ther same.
> If any developer of iptables reads this, I'd appreciate any thoughts
> on that.

The 'iptables -L' output, and the 'iptables' commandline interface,
will change, or so I've been told. Especially the commandline interface:
it is too flexible (permits you lots of variants in the order of options).

Things may be better with the iptables-save / iptables-restore file format,
or so I hope.

Note that I'm not involved in those rewrite activities, so all this
is second hand information. And I do think that the questions deserve
a reliable answer, regarding IF, WHEN, and HOW such a committment CAN
be made.

best regards
  Patrick
