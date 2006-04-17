From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC][PATCH] compat_uint64_t type
Date: Mon, 17 Apr 2006 13:20:26 -0700 (PDT)
Message-ID: <20060417.132026.72299574.davem@davemloft.net>
References: <200604171459.13312.dim@openvz.org> <4443B882.70203@trash.net>
	<4443BC5B.9000407@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: dim@openvz.org, schwab@suse.de, netfilter-devel@lists.netfilter.org,
	dev@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4443BC5B.9000407@trash.net>
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
Date: Mon, 17 Apr 2006 18:03:39 +0200

> Patrick McHardy wrote:
> > Dmitry Mishin wrote:
> > 
> >>This patch introduces compat_uint64_t type, which is required for proper 
> >>handling different alignment of structures, containing u64 objects, on 
> >>compatible with ia32 64bit platforms and others.
> 
> This is my proposed alternative. It assumes all architectures besides
> x86 use native alignment for basic types.

Ok.  Perhaps we can eventually define a CONFIG_* object for
this.
