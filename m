From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 3/3]: Fix HW checksum handling in TCPMSS target
Date: Sat, 20 Aug 2005 17:41:15 -0700 (PDT)
Message-ID: <20050820.174115.109677296.davem@davemloft.net>
References: <430689F7.5070305@trash.net>
	<4306919E.4000602@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4306919E.4000602@trash.net>
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
Date: Sat, 20 Aug 2005 04:12:46 +0200

> On second thought, this is not a good idea, we need to update the
> checksum in any case for forwarded packets. These patches should
> be better.

All 3 patches applied to both trees, thanks Patrick.
