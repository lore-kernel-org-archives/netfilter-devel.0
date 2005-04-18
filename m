From: Wang Jian <lark@linux.net.cn>
Subject: Re: double call to ip_conntrack_put() ?
Date: Mon, 18 Apr 2005 19:22:47 +0800
Message-ID: <20050418192122.037D.LARK@linux.net.cn>
References: <876ef97a05041802571f302bfe@mail.gmail.com>
	<426393C7.1020006@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Tobias DiPasquale <codeslinger@gmail.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <426393C7.1020006@ufomechanic.net>
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

Hi Amin Azez,

Yes, I am also confused by the _put for a while until I read the code.
IMHO, it's more clear to rename it to _release.

On Mon, 18 Apr 2005 12:02:31 +0100, Amin Azez <azez@ufomechanic.net> wrote:

> Tobias DiPasquale wrote:
> > This is intended. tuplehash_to_ctrack() generates a reference to the
> > conntrack record. In death_by_timeout() the refcount is decremented,
> > yielding 1 for the second call to ip_conntrack_put(). The dec_and_test
> > in nf_conntrack_put() (called by ip_conntrack_put()) will result in a
> > refcount of 0, sending the record to the destroy_conntrack() function
> > (or more properly, whatever's registered in nfct->destroy(), which I'm
> > pretty sure is always either NULL or destroy_conntrack()).
> 
> What I found confusing initially was that "put" in "ip_conntrack_put" 
> means "release" or "refcount--" instead of "write" or "store" which 
> would have been my first guess.
> 
> Sam Azez
> 



-- 
  lark
