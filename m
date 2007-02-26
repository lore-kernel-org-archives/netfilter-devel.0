From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
Date: Mon, 26 Feb 2007 16:21:56 -0500
Message-ID: <45E34F74.8050807@redhat.com>
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com>
	<45E04468.7020001@trash.net> <45E06546.504@redhat.com>
	<45E1C7E0.9070102@trash.net> <45E31572.4040108@redhat.com>
	<45E31EB5.6000809@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45E31EB5.6000809@trash.net>
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

Patrick McHardy wrote:
> This patch is against current stable-2.6.20, it applies
> cleanly to 2.6.20 as well.
> 

Everything works OK, but I get:

BUG: warning: (!list_empty(&unconfirmed)) at
net/netfilter/nf_conntrack_core.c:1068/nf_ct_cleanup()

<> nf_ct_cleanup+0x66/0x122 [nf_conntrack]
<> kill_l4proto+0x0 [nf_conntrack]
<> nf_conntrack_l4proto_unregister+0x7d/0x82 [nf_conntrack]
<> nf_conntrack_l3proto_ipv4_fini+0x3c/0x46 [nf_conntrack_ipv4]
<> sys_delete_module+0x18a/0x1b1
...

netconsole doesn't seem to work as a module for me, so hand
copied from screen.
