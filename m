From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: tcp_conntrack: factorize out the PUSH flag
Date: Tue, 13 Mar 2007 16:50:40 +0100
Message-ID: <45F6C850.5070107@trash.net>
References: <11736083633448-git-send-email-w@1wt.eu>
	<11736083633652-git-send-email-w@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
To: Willy Tarreau <w@1wt.eu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <11736083633652-git-send-email-w@1wt.eu>
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

Willy Tarreau wrote:
> The PUSH flag is accepted with every other valid combination.
> Let's get it out of the tcp_valid_flags table and reduce the
> number of combinations we have to handle. This does not
> significantly reduce the table size however (8 bytes).

Thanks Willy, both applied. I edited out the ip_conntrack parts
since that is already removed in my 2.6.22 tree.
