From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] compat_uint64_t type
Date: Fri, 21 Apr 2006 02:07:58 +0200
Message-ID: <4448225E.6010309@trash.net>
References: <200604171459.13312.dim@openvz.org>
	<4443B882.70203@trash.net>	<4443BC5B.9000407@trash.net>
	<20060417.132026.72299574.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: dim@openvz.org, schwab@suse.de, netfilter-devel@lists.netfilter.org,
	dev@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060417.132026.72299574.davem@davemloft.net>
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

David S. Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon, 17 Apr 2006 18:03:39 +0200
> 
>>This is my proposed alternative. It assumes all architectures besides
>>x86 use native alignment for basic types.
> 
> 
> Ok.  Perhaps we can eventually define a CONFIG_* object for
> this.

Since this appears to be a pure x86 32 bit emulation oddity
so far, I think CONFIG_IA32_EMULATION would express that
best. Unfortunately IA64 uses a different config option,
so I left it as is.

I'll send the patch with a batch of other fixes in a few hours.
