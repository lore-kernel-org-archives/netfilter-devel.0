From: "David S. Miller" <davem@davemloft.net>
Subject: Re: New draft document on nat / traversal / hole punching (with Dan
 Kegel)
Date: Tue, 9 Nov 2004 22:10:25 -0800
Message-ID: <20041109221025.6617b513.davem@davemloft.net>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<1100024526.6496.10.camel@tux.rsn.bth.se>
	<1100043724.25963.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	gandalf@wlug.westbo.se, coreteam@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1100043724.25963.19.camel@localhost.localdomain>
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

On Wed, 10 Nov 2004 10:42:04 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tue, 2004-11-09 at 19:22 +0100, Martin Josefsson wrote:
> > Rusty, iirc we have a problem in the NAT core when we SNAT and have to
> > remap ports, later SNAT'd connections from the same host:port pair
> > doesn't get the same mapping as the first one. You were working on a fix
> > for this? Was this ever made public?
> 
> Dave, please apply.  (Thanks for the reminder Martin).

Applied, thanks Rusty.
