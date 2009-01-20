From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] add --with-kernel-includes configure option to
 libnetfilter_queue
Date: Tue, 20 Jan 2009 17:49:03 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901201748090.31276@fbirervta.pbzchgretzou.qr>
References: <4975FC41.70906@pandora.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52717 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbZATQtG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2009 11:49:06 -0500
In-Reply-To: <4975FC41.70906@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-01-20 17:30, Bart De Schuymer wrote:
>
> +dnl Allows compiling the library with kernel include headers not located
> +dnl at /usr/include
> +AC_ARG_WITH([kernel-includes],
> +    [AS_HELP_STRING([--with-kernel-includes=PATH],
> +    [Path to kernel source include files @<:@default=/usr/include@:>@])],
> +    [
> +    if test x$withval = xyes -o x$withval = x ; then
> +	AC_MSG_ERROR(--with-kernel-includes must be given the path to your
> kernel source include files.)
> +    fi
> +    if ! test -d $withval ; then

I would say this should be
	if test ! -d "$withval"

similarly below and for the other patches.

> +    if ! test -d $withval/linux ; then
> +    if ! test -r $withval/linux ; then
