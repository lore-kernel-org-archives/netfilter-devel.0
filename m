From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH 13/18] Netfilter: Multiport revision with port ranges
	(replaces "mport")
Date: Tue, 4 Jan 2005 20:30:27 -0800
Message-ID: <20050105043027.GA23546@linuxace.com>
References: <1104896159.20582.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1104896159.20582.79.camel@localhost.localdomain>
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

On Wed, Jan 05, 2005 at 02:35:59PM +1100, Rusty Russell wrote:
> The multiport match doesn't support ranges of ports, so a new match
> called "mport" was written.  Now we have versioning of matches and
> targets, we can simply put this extension in multiport revision 1.

While I agree the above is a useful change, why not also add inversion
to multiport in the process -- as long as you're making a new revision?
Or should that be done in revision 2?

Phil
