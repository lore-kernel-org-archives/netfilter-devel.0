From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Fix some issues with non-linear packets
Date: Wed, 05 Jan 2005 14:01:14 +1100
Message-ID: <1104894074.20582.0.camel@localhost.localdomain>
References: <1104882714.1320.14.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1104882714.1320.14.camel@tux.rsn.bth.se>
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

On Wed, 2005-01-05 at 00:51 +0100, Martin Josefsson wrote:
> Hi Rusty
> 
> I've been playing with your latest nfsim stuff and found some issues
> with the kernel.
> You mentioned that you found some problems, so you might already have
> fixed these.

Yes, I think so.  I was too tired to send them out last night, sorry.

Please re-examine, I'm about to send out 18 patches.

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
