From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Correct signatur for target
Date: Tue, 24 Mar 2009 14:12:57 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903241410130.27859@fbirervta.pbzchgretzou.qr>
References: <17e3a8f80903240606v1efab2eds2a40a1dbe820af00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38106 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367AbZCXNNA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:13:00 -0400
In-Reply-To: <17e3a8f80903240606v1efab2eds2a40a1dbe820af00@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-03-24 14:06, Kristian Evensen wrote:
>
>I am currently working on an xtables-targetmodule, and have come
>across a thing that puzzles me a little bit. As far as I have
>understood it, according to both the book "Writing netfilter module"
>(excellent by the way, thank you Jan and Nicolas) and my
>x_tables.h-file, the signatur for *target is:
>
>static unsigned int (*target) (struct sk_buff *skb,
>			       const struct xt_target_param *par)
>
>However, to get it working on my machine (which runs the
>2.6.28.8-kernel), the first argument had to be a double pointer for my
>module to work as intended. I though the double pointer was there for
>compatibility with older kernels. Does any know where I am wrong/what
>I have done wrong?

To make Xtables-addons's compat_xtables.ko work with all supported
kernel versions, it has to slightly deviate from the latest kernel
API and use a double-pointer. So if you write your module with the
help of the compat layer, you need to be aware of this minor
difference. I think the latest version of the e-book also mentions
this.
