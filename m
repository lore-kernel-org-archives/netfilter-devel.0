From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] KERNEL_DIR support in autogen.sh for
	libnfnetlink/libnetfilter_conntrack
Date: Tue, 15 Nov 2005 01:25:22 +0100
Message-ID: <43792AF2.9040700@eurodev.net>
References: <Pine.LNX.4.64.0511150044020.15324@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0511150044020.15324@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> Attached two patches for libnfnetlink and libnetfilter_conntrack allow
> user to specify custom KERNEL_DIR like in iptables build. If KERNEL_DIR
> is empty default directory - "/lib/modules/`uname -r`/build" is used.

The patches look fine. Could you resend the same patch including
libnetfilter_queue and libnetfilter_log as well? That way we'll keep all
the libnetfilter_* friends in sync. Thanks!

-- 
Pablo
