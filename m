From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] priv_data 0/2
Date: Mon, 03 Jul 2006 20:33:03 +0200
Message-ID: <44A962DF.3080406@trash.net>
References: <200606261641.47294.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200606261641.47294.max@nucleus.it>
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

Massimiliano Hofer wrote:
> Hi,
> this is a version of my priv_data patch that updates targets and renames 
> functions as suggested by Patrick.
> 
> Since xt_init_match() and xt_init_target() (formerly xt_check_match() and 
> xt_check_target()) no longer just check and they needed some argument changes 
> anyway, I included some more common code previously replicated in 
> ip_tables.c, ip6_tables.c and arp_tables.c.
> Similarly I introduced xt_destroy_match() and xt_destroy_taget().
> 
> The resulting patches are larger than I anticipated, but most of the space is 
> taken by function ranames and argument adjustments.
> 
> My previous example with xt_condition still applies (just rename checkentry to 
> init in struct xt_match).
> 
> I tested several combination with iptables, ip6tables and arptables. It can't 
> make it fail, but I didn't try it with a real world network load. Right now I 
> don't have a 64 bit machine available for testing (I should be able to use 
> one in a few days), so I didn't test compat at all.
> 
> Testing and comments, as always, are appreciated.

Nice work, thanks Massimiliano. I'll have a closer look later and will
probably apply it tommorrow. I hope we can still get this in 2.6.18.
