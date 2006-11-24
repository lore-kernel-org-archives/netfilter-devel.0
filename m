From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2]: nf_conntrack: fix the race on assign helper to new
 conntrack
Date: Fri, 24 Nov 2006 11:07:18 +0100
Message-ID: <4566C456.1000400@trash.net>
References: <200611231718.kANHIMtk027611@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200611231718.kANHIMtk027611@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> The found helper cannot be assigned to conntrack after unlocking
> nf_conntrack_lock. This tries to find helper to assign again.

Both applied, thanks.

BTW, we have quite a few more helper races. Basically all code
not holding nf_conntrack_lock relies on the synchronize_net()
in nf_conntrack_helper_unregister() for help->helper not to
go away. But there is neither rcu disabling (but we can rely
on nf_hook_slow for this in most of the code) nor copying the
pointer before checking and derefencing it anywhere.

The same is true for all the NAT hook funtions, and probably others.
