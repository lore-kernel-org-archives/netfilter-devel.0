From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] connrate missing exports fixed
Date: Thu, 17 Mar 2005 15:45:37 +0100
Message-ID: <42399811.9080009@trash.net>
References: <4239920B.30906@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <4239920B.30906@outerspace.dyndns.org>
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

Jonas Berlin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Connrate is missing two exports, which makes the kernel compilation fail if
> either ip_conntrack or ipt_connrate is compiled as a module.

Applied to trunk and the 2.6.11 branch, thanks.

Regards
Patrick
