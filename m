From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 13/18] Netfilter:  Multiport revision with port ranges
	(replaces "mport")
Date: Wed, 05 Jan 2005 16:46:54 +1100
Message-ID: <1104904015.20582.91.camel@localhost.localdomain>
References: <1104896159.20582.79.camel@localhost.localdomain>
	<20050105043027.GA23546@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050105043027.GA23546@linuxace.com>
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

On Tue, 2005-01-04 at 20:30 -0800, Phil Oester wrote:
> On Wed, Jan 05, 2005 at 02:35:59PM +1100, Rusty Russell wrote:
> > The multiport match doesn't support ranges of ports, so a new match
> > called "mport" was written.  Now we have versioning of matches and
> > targets, we can simply put this extension in multiport revision 1.
> 
> While I agree the above is a useful change, why not also add inversion
> to multiport in the process -- as long as you're making a new revision?
> Or should that be done in revision 2?

If you put it in before 2.6.11 is released, it can go in the current
revision, otherwise we want a new one (where do we put the invert
flags?).

Cheers,
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
