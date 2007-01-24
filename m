From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER]: Fix iptables ABI breakage on (at least) CRIS
Date: Tue, 23 Jan 2007 22:00:35 -0800 (PST)
Message-ID: <20070123.220035.39158206.davem@davemloft.net>
References: <45ACDB15.60003@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45ACDB15.60003@trash.net>
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
Date: Tue, 16 Jan 2007 15:03:01 +0100

> [NETFILTER]: Fix iptables ABI breakage on (at least) CRIS
> 
> With the introduction of x_tables we accidentally broke compatibility
> by defining IPT_TABLE_MAXNAMELEN to XT_FUNCTION_MAXNAMELEN instead of
> XT_TABLE_MAXNAMELEN, which is two bytes larger.
> 
> On most architectures it doesn't really matter since we don't have
> any tables with names that long in the kernel and the structure
> layout didn't change because of alignment requirements of following
> members. On CRIS however (and other architectures that don't align
> data) this changed the structure layout and thus broke compatibility
> with old iptables binaries.
> 
> Changing it back will break compatibility with binaries compiled
> against recent kernels again, but since the breakage has only been
> there for three releases this seems like the better choice.
> 
> Spotted by Jonas Berlin <xkr47@outerspace.dyndns.org>.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, push this to -stable if you haven't already Patrick.

Thanks.
