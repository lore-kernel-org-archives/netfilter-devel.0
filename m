From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: New draft document on nat / traversal / hole punching (with
	Dan Kegel)
Date: Thu, 11 Nov 2004 11:30:56 +1100
Message-ID: <1100133056.9643.23.camel@localhost.localdomain>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<1100024526.6496.10.camel@tux.rsn.bth.se>
	<1100043724.25963.19.camel@localhost.localdomain>
	<20041110162500.GA7485@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>, coreteam@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041110162500.GA7485@sunbeam.de.gnumonks.org>
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

On Wed, 2004-11-10 at 17:25 +0100, Harald Welte wrote:
> On Wed, Nov 10, 2004 at 10:42:04AM +1100, Rusty Russell wrote:
> > Name: Fix find_appropriate_src() To Actually Work
> > Status: Tested under nfsim
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> > [...]
> 
> > -			if (newtuple.src.ip != tuple->src.ip)
> > +			if (tuple->src.ip != tuple->src.ip)
> 
> Rusty, are you sure this is really what you want?  ;)

Ew... Dave, please drop that patch as it was crap.

I merged two patches (a cleanup and the fix) and didn't re-test.

I'll fix, test and re-send.

Sorry,
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
