From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 1/5]: Fix deadlock in ip6_queue
Date: Fri, 22 Jul 2005 12:49:53 -0700 (PDT)
Message-ID: <20050722.124953.120444742.davem@davemloft.net>
References: <42E0A1C6.3040300@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42E0A1C6.3040300@trash.net>
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
Date: Fri, 22 Jul 2005 09:35:34 +0200

> [NETFILTER]: Fix deadlock in ip6_queue
> 
> Already fixed in ip_queue, ip6_queue was missed.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
