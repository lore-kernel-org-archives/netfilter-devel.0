From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] libipt_statistic
Date: Mon, 2 Jul 2007 21:55:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707022153450.28721@fbirervta.pbzchgretzou.qr>
References: <dd45289d0707011710v189ac25j174458fecb0bfb41@mail.gmail.com>
	<4688F979.60606@trash.net>
	<dd45289d0707020751j6bb5de27k25bc73e4337c818b@mail.gmail.com>
	<46891294.9030405@trash.net>
	<dd45289d0707021038p42e1871n200d2c425d50797c@mail.gmail.com>
	<4689387A.4050207@trash.net>
	<dd45289d0707021105q6b70c23m45135e0a56ccb5aa@mail.gmail.com>
	<46894116.9000203@trash.net>
	<dd45289d0707021210s53005cbfodff90f97f6ed69da@mail.gmail.com>
	<46894E8C.4070306@trash.net>
	<dd45289d0707021238i7394ace5g552d8c170f0cb78d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <dd45289d0707021238i7394ace5g552d8c170f0cb78d@mail.gmail.com>
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


On Jul 2 2007 14:38, NICOLAS BOULIANE wrote:
>
> Signed-off-by: Nicolas Bouliane
>
> comments are welcome,
> thanks

inline patches preferred..

>Index: libipt_statistic.c
>===================================================================
>--- libipt_statistic.c	(revision 6898)
>+++ libipt_statistic.c	(working copy)
>@@ -113,6 +113,15 @@
> 	if (flags & 0x8 && info->mode != XT_STATISTIC_MODE_NTH)
> 		exit_error(PARAMETER_PROBLEM,
> 			   "--packet can only be used in nth mode");
>+	if ((flags & 0x8) && !(flags & 0x4))

This could perhaps be

	if ((flags & 0xC) == 0x8)


	Jan
-- 
