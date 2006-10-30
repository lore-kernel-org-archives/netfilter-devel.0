From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 03/05]: ip_tables: compat error way cleanup
Date: Mon, 30 Oct 2006 15:13:36 -0800 (PST)
Message-ID: <20061030.151336.126790975.davem@davemloft.net>
References: <20061030181853.32038.97693.sendpatchset@localhost.localdomain>
	<20061030181857.32038.43247.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061030181857.32038.43247.sendpatchset@localhost.localdomain>
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
Date: Mon, 30 Oct 2006 19:19:00 +0100 (MET)

> [NETFILTER]: ip_tables: compat error way cleanup
> 
> This patch adds forgotten compat_flush_offset() call to error way of
> translate_compat_table().  May lead to table corruption on the next
> compat_do_replace().
> 
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> Acked-by: Dmitry Mishin <dim@openvz.org>
> Acked-by: Kirill Korotaev <dev@openvz.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
