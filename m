From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 2/5]: Fix potential memory corruption in NAT code
 (aka memory NAT)
Date: Fri, 22 Jul 2005 12:50:42 -0700 (PDT)
Message-ID: <20050722.125042.08650480.davem@davemloft.net>
References: <42E0A1CF.7090509@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42E0A1CF.7090509@trash.net>
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
Date: Fri, 22 Jul 2005 09:35:43 +0200

> [NETFILTER]: Fix potential memory corruption in NAT code (aka memory NAT)
> 
> The portptr pointing to the port in the conntrack tuple is declared static,
> which could result in memory corruption when two packets of the same
> protocol are NATed at the same time and one conntrack goes away.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks.
