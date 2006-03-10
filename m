From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] {get|set}sockopt compatibility layer
Date: Fri, 10 Mar 2006 03:34:53 -0800 (PST)
Message-ID: <20060310.033453.53342192.davem@davemloft.net>
References: <200603091324.00362.dim@openvz.org>
	<20060309.152934.99760924.davem@davemloft.net>
	<200603101421.10920.dim@openvz.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: akpm@osdl.org, dev@openvz.org, netfilter-devel@lists.netfilter.org,
	arnd@arndb.de, rusty@rustcorp.com.au,
	linux-kernel@vger.kernel.org, devel@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dim@openvz.org
In-Reply-To: <200603101421.10920.dim@openvz.org>
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

From: Dmitry Mishin <dim@openvz.org>
Date: Fri, 10 Mar 2006 14:21:10 +0300

> This patch extends {get|set}sockopt compatibility layer in order to move 
> protocol specific parts to their place and avoid  huge universal net/compat.c 
> file in the future.
> 
> Signed-off-by: Dmitry Mishin <dim@openvz.org>

Applied, thanks Dmitry.

Please give "-p1" format patches in the future, I fixed your's
up by hand so could feed it to git.

Thanks again.
