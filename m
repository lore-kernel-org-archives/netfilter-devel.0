From: Cody Tubbs <tubbs@wispdirect.com>
Subject: Re: ipv4options still broken (posted prev w/ no reply)...
Date: Tue, 30 May 2006 14:16:21 -0700
Message-ID: <1149023782.28886.28.camel@mbox>
References: <1149011224.28886.14.camel@mbox>  <447C9B8A.20304@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <447C9B8A.20304@trash.net>
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

I'm not going to indulge in 101 stuff regarding loose/strict source 
attacks, google enjoys 101 much more.

http://www.spirit.com/Network/net0300.html (section: Source Route)

http://seclists.org/lists/pen-test/2003/May/0023.html

Patch coming soon.

-Cody Tubbs


On Tue, 2006-05-30 at 21:22 +0200, Patrick McHardy wrote:
> Cody Tubbs wrote:
> > While we're on the nth match topic and speaking of broken modules in
> > pom, I posted a couple of weeks ago about the lsrr and ssrr options
> > being broken in the ipv4options module.  I had dialog with Fabrice, but
> > it seems he doesn't have time to maintain the module anymore, or at
> > least fix this issue.  It's giving everyone who is using it a false
> > sense of security, being that it loads, but doesn't do anything when an
> > lsrr/ssrr ip option is set and passes through the module.  Can this be
> > removed until it's fixed?  lsrr and ssrr are critical ip options to
> > monitor attempting to enter your network, and people using this module
> > thinking/expecting it to work can possibly get compromised via its lack
> > of mojo.  Thanks.
> 
> I somehow doubt that this is really a threat, but feel free to send
> a patch to disable those two options until fixed.
