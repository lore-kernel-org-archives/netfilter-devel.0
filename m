From: "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.12 netfilter: local packets marked as invalid
Date: Tue, 12 Jul 2005 11:58:35 -0700 (PDT)
Message-ID: <20050712.115835.42775885.davem@davemloft.net>
References: <42CE8E96.1040905@trash.net> <42CEA5E4.40009@gentoo.org>
	<42D3B063.3000207@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: dsd@gentoo.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42D3B063.3000207@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 12 Jul 2005 13:58:27 +0200

> Daniel Drake wrote:
> > You'll have to forgive my lack of netfilter knowledge, I set up my firewall
> > ages ago and haven't really touched it since :)
> 
> We decided to revert the responsible change because it caused problems
> in other areas as well. This patch should fix your problem.

Applied.

Now the question is what to do about the 2.6.12.x stable
tree.  I think we put the offending change there, now we
need to revert it there too.  Patrick, could you push this
patch to stable@kernel.org so we can resolve that too?

Thanks a lot.
