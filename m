From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Fri, 28 Jun 2002 08:23:39 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020628082339.I2890@oknodo.bof.de>
References: <15643.31140.525551.843205@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15643.31140.525551.843205@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Thu, Jun 27, 2002 at 01:46:28PM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Don,

> I had mentioned that I was hoping to remember/find the appropriate
> formula for the probability of a hash bucket reaching its limit.

[SNIP calculation - thanks for sharing your research!]

> I assume that the hash function maps a connection to each bucket
> with equal probability, P = 1/B.

Can you find an analysis that permits some non-uniformity, given as
a parameter?  I am pretty sure that the hash function we use for
conntracking is nonuniform in lots of real world cases. Thus, if
you want to propose using that probability derived length limit,
then you must prove uniformity of our hash function.

I have the vague feeling (being a programmer, not a mathematician :)
that even small nonuniformities will have large impact on your
probability distribution.

May I suggest a different, experimental approach: extract the hash function
from the code, creating a small userlevel tool which reads in the saved
contents of some /proc/net/ip_conntrack, and with a hash bucket and limit
specified on the commandline, counts the distribution for that specific
set of connections, maybe comparing it with the theoretical prediction,
resulting in a "how does that real world conntrack table fit to theory"
metric? Once done, such a tool could permit command line selection of
different hash functions, for comparison.

best regards
  Patrick
