From: Patrick Schaaf <bof@bof.de>
Subject: Re: iptables -L %table% <with rule matching>
Date: Thu, 30 Jan 2003 07:59:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030130065942.GA20695@oknodo.bof.de>
References: <200FAA488DE0D41194F10010B597610D5BEB1B@jupiter.citadelcomputer.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: George Vieira <GeorgeV@citadelcomputer.com.au>
Content-Disposition: inline
In-Reply-To: <200FAA488DE0D41194F10010B597610D5BEB1B@jupiter.citadelcomputer.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 30, 2003 at 12:04:33PM +1100, George Vieira wrote:
> With the no response to my last request, I guess everybody has their own
> patching projects and/or cannot help me with mine? 

No. It's just that the last 20 times such a topic came up, the
unanimous answer on this development list was "iptables userspace
is broken by design, we don't want to meddle with it more than
absolutely neccessary."

There are specific reasons, one of them making your proposal
a lot less intresting: even when you have a "delete me this rule"
option, the command will nevertheless pull the whole table out
of the kernel, modify it, and write the full table back to the
kernel.

There are solutions, e.g. the ctnetlink patch, which show how to
approach that general problem group. People are in the process
of developing such a new user space framework, but nothing usable
has come from this, yet.

In any case, not many people seem keen to even think about giving
the existing iptables user space more than bugfixes; any patch to
functionality is seen as waste of time, as far as I can tell.

As this situation has not changed for the whole last year, and the
questions like yours come in every one or two weeks, you should not
be too surprised that they are just ignored.

best regards
  Patrick
