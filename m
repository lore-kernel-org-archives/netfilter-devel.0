From: Patrick Schaaf <bof@bof.de>
Subject: Re: /etc/sysconfig/iptables format
Date: Sun, 24 Nov 2002 11:40:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021124104018.GC14672@oknodo.bof.de>
References: <Pine.LNX.4.44.0211200005530.5235-100000@azalea.cs.jmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Arch Harris <netfilter02@jah.cs.jmu.edu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0211200005530.5235-100000@azalea.cs.jmu.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Arch,

[regarding iptables-save format]

> I realize the syntax fllows the iptables command arguments.  But there
> are some differences.  Things like: *filter, COMMIT, etc.  I think
> I have figured most of this stuff out, but a man page and/or HOWTO
> chapter describing the file format sure would be nice.

I agree to the need for docs (do you volunteer writing them?), if, and
only if, at the same time, future compatibility promises regarding the
format, are carefully formulated. I'd propose "can change completely
any time soon when the new pkttables replaces the current mess that
is iptables". To Harald Welte: would that be an appropriate formulation?

As far as I know, the format was never intended for end user usage,
and distributions (redhat, in your case, right?) were wrong basing
their operation on it. At least the Debian maintainers seem to be
aware of that fact, as the comments in the relevant startup scripts
basically say not to use or rely on them (my information stemming
from the Woody distribution of Debian.)

Personally, I write my iptables "templates" in the traditional shell
script form, executing anew on each boot, and when I need to change
the rules, I change the scripts, and rerun "init.d/xxx start".
Sometimes, first I prototype the change by modifying the running
ruleset. Never do I use save/restore. The lack of structure and
comments alone, is reason enough for me to avoid going that route.

best regards
  Patrick
