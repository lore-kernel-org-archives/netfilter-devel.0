From: Andre Uratsuka Manoel <andre@insite.com.br>
Subject: Re: IPtables performance (fwd)
Date: Wed, 28 May 2003 19:28:25 -0300 (BRT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305281924170.5707-100000@fantomas.insite.com.br>
References: <20030528192019.GC12978@naboo>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Chris Wilson <chris@netservers.co.uk>,
	"netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>,
	Robert Olsson <robban@robtex.com>,
	John McEleney <john@netservers.co.uk>,
	Ben McKeegan <ben@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030528192019.GC12978@naboo>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 28 May 2003, Harald Welte wrote:

> On Sat, May 03, 2003 at 07:39:46PM -0300, Andre Uratsuka Manoel wrote:
> 
> > 	Be my guest to implement it. I thought of doing it myself, but I'm
> > still looking around and trying to understand all those structures and
> > pointers and I am still trying to find my way around.
> 
> While a long train ride I recently had the time to think about your
> algorithm and I really like it.  I even started with an implementation,
> but came to the following problem:
> 
> > 	Here is the pseudo-code for the algorithm:
> > 
> > -------------------------------------------------
> > 	for every chain:
> > 		paint it white 
> > 		set chain->comefrom to 0 
> 
> how can we safely iterate over the whole table (which might contain
> loops) and paint all chains white?  I mean, if there is a loop in it,
> already the initialization-to-white function would loop indefinitely.
> 
> any ideas?

	You could IPT_ENTRY_ITERATE. It would be fast and hassle-free...

	Andre
