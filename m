From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/05]: compat offsets size change
Date: Thu, 04 Jan 2007 12:14:56 -0800 (PST)
Message-ID: <20070104.121456.94889870.davem@davemloft.net>
References: <20070104183820.18369.3658.sendpatchset@localhost.localdomain>
	<20070104183821.18369.7005.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20070104183821.18369.7005.sendpatchset@localhost.localdomain>
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
Date: Thu,  4 Jan 2007 19:38:22 +0100 (MET)

> [NETFILTER]: compat offsets size change
> 
> Used by compat code offsets of entries should be 'unsigned int' as entries
> array size has this dimension.
> 
> Signed-off-by: Dmitry Mishin <dim@openvz.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
