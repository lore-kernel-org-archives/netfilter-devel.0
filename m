From: Jeremy Kerr <jk@ozlabs.org>
Subject: Re: nfsim updates
Date: Wed, 22 Sep 2004 21:04:36 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409222104.36526.jk@ozlabs.org>
References: <20040919223457.GL1307@sunbeam.de.gnumonks.org>
	<1095732625.1940.166.camel@bach>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1095732625.1940.166.camel@bach>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> > As stated before, we could also move it to
> > svn.netfilter.org (which actually exists, but also has no public
> > interface yet).
>
> Jeremy?

This would probably be the best way to go - It also depends on how the 
netfilter testsuite is going to be developed - would using the subversion 
repository cause any problems, rather than rolling it into netfilter cvs?

In the meantime though, I've set up a cron task to create a nightly snapshot 
from the ozlabs.org subversion repository (23:00 AEST). This puts the .tar.gz 
up at:

 http://ozlabs.org/~jk/projects/nfsim/



Jeremy
