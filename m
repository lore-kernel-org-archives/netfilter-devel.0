From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip6tables multiport does not support x:y
Date: Mon, 03 Jul 2006 20:09:01 +0200
Message-ID: <44A95D3D.9010609@trash.net>
References: <20060701213533.GA28395@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20060701213533.GA28395@linuxace.com>
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

Phil Oester wrote:
> Update the manpage for ip6tables multiport match to reflect
> reality -- it does not (yet) support x:y syntax.  I looked at
> adding it, but adding revision support to ip6tables seems a
> waste at this point, since once xtables support is added to
> iptables, this problem will resolve itself.

Agreed, Harald was already working on this some time ago.

> Closes bug #451.

Applied, thanks.
