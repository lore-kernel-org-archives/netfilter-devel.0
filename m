From: Wang Jian <lark@linux.net.cn>
Subject: Re: double call to ip_conntrack_put() ?
Date: Mon, 18 Apr 2005 18:25:29 +0800
Message-ID: <20050418182442.0375.LARK@linux.net.cn>
References: <20050418171657.0370.LARK@linux.net.cn>
	<876ef97a05041802571f302bfe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a05041802571f302bfe@mail.gmail.com>
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

Hi Tobias DiPasquale,


On Mon, 18 Apr 2005 05:57:30 -0400, Tobias DiPasquale <codeslinger@gmail.com> wrote:

> 
> This is intended. tuplehash_to_ctrack() generates a reference to the
> conntrack record. In death_by_timeout() the refcount is decremented,
> yielding 1 for the second call to ip_conntrack_put(). The dec_and_test
> in nf_conntrack_put() (called by ip_conntrack_put()) will result in a
> refcount of 0, sending the record to the destroy_conntrack() function
> (or more properly, whatever's registered in nfct->destroy(), which I'm
> pretty sure is always either NULL or destroy_conntrack()).
> 

Thanks for your clear answer :)

-- 
  lark
