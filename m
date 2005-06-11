From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] kill build warnings in ipt_ACCOUNT.c
Date: Sat, 11 Jun 2005 18:02:42 +0200
Message-ID: <42AB0B22.7090703@trash.net>
References: <200505201352.27915.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pawel Sikora <pluto@agmk.net>
In-Reply-To: <200505201352.27915.pluto@agmk.net>
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

Pawel Sikora wrote:
>   CC [M]  net/ipv4/netfilter/ipt_ACCOUNT.o
> net/ipv4/netfilter/ipt_ACCOUNT.c: In function 'ipt_acc_handle_prepare_read':
> net/ipv4/netfilter/ipt_ACCOUNT.c:610: warning:
>  ISO C90 forbids mixed declarations and code
> net/ipv4/netfilter/ipt_ACCOUNT.c: At top level:
> net/ipv4/netfilter/ipt_ACCOUNT.c:1024: warning:
>  initialization from incompatible pointer type

Applied, thanks.
