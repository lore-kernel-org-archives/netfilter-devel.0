From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RESEND 2] [1/2] OSF: fix 2.4 compilation.
Date: Wed, 07 Dec 2005 00:59:45 +0100
Message-ID: <439625F1.2080805@trash.net>
References: <20051206135158.GA27686@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
In-Reply-To: <20051206135158.GA27686@2ka.mipt.ru>
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

Evgeniy Polyakov wrote:
> Bug found by Aleksey Barabanov <alekseybb mail.ru>.
> Thank you.
> 
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> 
> --- net/ipv4/netfilter/ipt_osf.c.orig	2005-11-26 15:29:33.000000000 +0300
> +++ net/ipv4/netfilter/tmp/ipt_osf.c	2005-11-26 15:29:05.000000000 +0300

I've already applied this some time ago, with some manual editing.
Please base your patches on the patch-o-matic root and make them
apply with -p1.
