From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack build warning
Date: Thu, 16 Mar 2006 00:50:38 +0100
Message-ID: <4418A84E.5080406@trash.net>
References: <20060315112315.6158ad7c@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
In-Reply-To: <20060315112315.6158ad7c@localhost.localdomain>
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

Stephen Hemminger wrote:
> Recent kernels in -mm warn about init section usage in ip_conntrack.
> The problem is the init_or_cleanup() style makes it impossible to compile
> time checking hard.
> 
> WARNING: net/ipv4/netfilter/ip_conntrack.o - Section mismatch:
> reference to .init.text:ip_conntrack_init from .text.init_or_cleanup
> after 'init_or_cleanup' (at offset 0x12)

The code should be fine, although I'm not a big fan of these
functions either. ip_conntrack_init is marked __init and is
called from init_or_cleanup, which is not marked, but only
on the init path.

I'd happily take a patch which cleans up these functions (we
have lots of them in the netfilter code).
