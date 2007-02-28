From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
Date: Wed, 28 Feb 2007 15:30:59 -0500
Message-ID: <45E5E683.7000509@redhat.com>
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com>
	<45E04468.7020001@trash.net> <45E06546.504@redhat.com>
	<45E1C7E0.9070102@trash.net> <45E31572.4040108@redhat.com>
	<45E31EB5.6000809@trash.net> <45E34F74.8050807@redhat.com>
	<45E5C549.2030009@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45E5C549.2030009@trash.net>
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
> Thanks, the previous approach doesn't seem to work properly without
> unpleasant event cache hacks. This patch takes a simpler approach
> and keeps the unconfirmed list iteration, but makes sure to make
> forward progress.
> 
> 
> 
> ------------------------------------------------------------------------
> 
> [NETFILTER]: conntrack: fix {nf,ip}_ct_iterate_cleanup endless loops
> 
> Fix {nf,ip}_ct_iterate_cleanup unconfirmed list handling:
> 

Works great: survived three reboots without lockup or warning messages.
And it's a nice simple patch, too...
