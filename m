From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: nfsim updates
Date: Tue, 21 Sep 2004 12:13:39 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1095732625.1940.166.camel@bach>
References: <20040919223457.GL1307@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jeremy Kerr <jk@ozlabs.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040919223457.GL1307@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2004-09-20 at 08:34, Harald Welte wrote:
> Hi!
> 
> I was actually over the last days using nfsim for useful debugging the
> first time :)
> 
> Please review (+ integrate?) the following changes:
> 
> 1) add open/fopen support to fakesockopt (for iptables-save)
> 2) block SIGCHILD in message.c (if exec()ed program dies)
> 3) fix wrong "((len = read(fd, msg, sizeof(*msg)) != sizeof(*msg)))"
> 4) add iptables-save and iptables-restore as commands

Committed, with some minor changes to merge with later work.  I'll also
be committing the nfsim-related testcases soon.

> btw: Could you please make your current SVN tree publicly accessible
> at some point?  As stated before, we could also move it to
> svn.netfilter.org (which actually exists, but also has no public
> interface yet).

Jeremy?

Thanks!
Rusty.
-- 
Anyone who quotes me in their signature is an idiot -- Rusty Russell
