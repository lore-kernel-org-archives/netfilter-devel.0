From: Phil Oester <kernel@linuxace.com>
Subject: Re: Problem with apply patch connlimit to 2.6.10 (debian 2.6.10-6)
Date: Fri, 25 Mar 2005 17:17:42 -0800
Message-ID: <20050326011742.GA4239@linuxace.com>
References: <20050325234332.GD10616@samad.com.au>
	<20050326001504.GE10616@samad.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050326001504.GE10616@samad.com.au>
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

On Sat, Mar 26, 2005 at 11:15:04AM +1100, Alexander Samad wrote:
> > I have had a look in include/linux/netfilter_ipv4/ip_conntrack.h  and it
> > seems like the structure has gone  and I am not sure what else I need to
> > apply to make it compile.
> 
> I noticed on bugszilla there is an open bug about connlimit not
> compiling on 2.6.11 (Bugzilla Bug 317) and the patch seems to remove any
> access to infos !  Should i be using the patch attached to this bugzilla

Yes, although 317 is a dupe of 268.  The fix is already applied to the 
2.6.11 branch of POM-NG.

Which raises the question (Harald?) - can we now make the 2.6.11 branch
the primary one?

Phil
