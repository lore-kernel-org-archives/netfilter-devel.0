From: Willy Tarreau <willy@w.ods.org>
Subject: Re: scripts for adding rulesets for performance testing?
Date: Fri, 10 Oct 2003 09:29:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031010072921.GA6712@alpha.home.local>
References: <20031009211452.GA16165@sirius.cs.pdx.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kristen Carlson <kristenc@cs.pdx.edu>
Content-Disposition: inline
In-Reply-To: <20031009211452.GA16165@sirius.cs.pdx.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Oct 09, 2003 at 02:14:52PM -0700, Kristen Carlson wrote:
> Hi there.  I'm doing some performance testing of iptables with increasing
> rulesets and am wondering if anybody already has some scripts for adding
> rules (many many rules) that they would like to share?  I noticed in the
> archives that the nf-hipac folks had posted a link to a script they had used
> for their performance testing which seemed to do exactly what I wanted, 
> but the link is busted. 

If your problem is "how to load a very high number of rules in a limited time",
then I strongly suggest that you use iptables-restore, which will load them
instantly at once. I have a ppro200 somewhere which takes less than a second
to load 4000 nat rules with it, while loading iptables for each of them took
ages (>15mn).

If your problem is "how to generate a lot of non-matching rules", then a simple
for() loop in shell, possibly including randoms will do the trick.

Hoping this helps
Willy
