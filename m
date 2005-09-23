From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH nfsim] port nfsim to Linux 2.6.14-rc2
Date: Fri, 23 Sep 2005 12:17:04 +0200
Message-ID: <20050923101704.GA5090@roonstrasse.net>
References: <20050922081813.GA21617@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050922081813.GA21617@roonstrasse.net>
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

On 2005/09/22 10:18, Max Kellermann <max@duempel.org> wrote:
> this patch makes nfsim compile with Linux 2.6.14-rc2.  It uses #ifdefs
> to keep it compatible with the older kernels.  The changes were mostly
> copy+paste from the original kernel headers to core/core.h etc.

By the way, my patch is not complete.  I just tried to run my test
suite, and it failed whenever ip_nat_mangle_tcp_packet() was called.
2.6.14 changes the way skb_ip_make_writable() / skb_make_writable()
work.  I am already working on an additional patch which correctly
implements skb_make_writable() in nfsim.

Max
