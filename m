From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 05/05]: ip_tables: compat code module refcounting fix
Date: Mon, 30 Oct 2006 15:14:41 -0800 (PST)
Message-ID: <20061030.151441.18606103.davem@davemloft.net>
References: <20061030181853.32038.97693.sendpatchset@localhost.localdomain>
	<20061030181900.32038.38847.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061030181900.32038.38847.sendpatchset@localhost.localdomain>
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
Date: Mon, 30 Oct 2006 19:19:03 +0100 (MET)

> [NETFILTER]: ip_tables: compat code module refcounting fix
> 
> This patch fixes bug in iptables modules refcounting on compat error way.
> 
> As we are getting modules in check_compat_entry_size_and_hooks(), in case of
> later error, we should put them all in translate_compat_table(), not  in the
> compat_copy_entry_from_user() or compat_copy_match_from_user(), as it is now.
> 
> Signed-off-by: Dmitry Mishin <dim@openvz.org>
> Acked-by: Vasily Averin <vvs@openvz.org>
> Acked-by: Kirill Korotaev <dev@openvz.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
