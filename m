From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2.6.10]: Fix memory leak in ip_conntrack_ftp
Date: Wed, 8 Dec 2004 13:58:16 -0800
Message-ID: <20041208135816.6fc7d00a.davem@davemloft.net>
References: <41B774EA.9030002@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41B774EA.9030002@trash.net>
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

On Wed, 08 Dec 2004 22:40:58 +0100
Patrick McHardy <kaber@trash.net> wrote:

> this patch fixes a remotely triggerable memory leak in ip_conntrack_ftp.
> exp leaks when a FTP date connection to a host different from the client
> (FXP) is attempted and the loose option is not set. It should go in
> 2.6.10 in my opinion.

I agree, I'll push this to Linus today.

Thanks.
