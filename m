From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: xt_connlimit 20070707 kernel
Date: Fri, 13 Jul 2007 23:18:55 +0900 (JST)
Message-ID: <200707131418.l6DEIucl013838@toshiba.co.jp>
References: <46925543.6060205@trash.net> <46925580.9030608@trash.net>
	<Pine.LNX.4.64.0707091737550.2887@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707091737550.2887@fbirervta.pbzchgretzou.qr>
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


Hi,

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Mon, 9 Jul 2007 17:38:52 +0200 (CEST)

> On Jul 9 2007 17:34, Patrick McHardy wrote:
> >>>Does it still make it into 2.6.23-rc1?
> >
> >> Yes, unless it fails during testing :)
> >
> >Speaking of which, could you resend the latest version of the
> >corresponding iptables patch please?
> >
> At your service!
> 
> (Note the symlink, or how [sw]ould this be done?)
> 
> 
> Thanks,
> 	Jan
> ===
> 
> Subject: Add connlimit to iptables.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> ---
> 

[...]

> +static __attribute__((constructor)) void libipt_connlimit_init(void)
> +{
> +	register_match(&connlimit_reg);
> +}

JFYI: I've fixed compile error in the case of NO_SHARED_LIBS=1. The
function name for initialization needs to be _init, not
libipt_connlimit_init.

-- Yasuyuki Kozakai
