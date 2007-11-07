From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/3] iptables-edit: iptables-edit: adds --table to
 iptables-restore
Date: Wed, 7 Nov 2007 21:42:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711072139430.20249@fbirervta.pbzchgretzou.qr>
References: <472E6041.7090601@endian.com> <Pine.LNX.4.64.0711071150390.1982@fbirervta.pbzchgretzou.qr>
 <4731C14F.50607@endian.com> <Pine.LNX.4.64.0711071737520.20249@fbirervta.pbzchgretzou.qr>
 <473200BD.10803@endian.com> <Pine.LNX.4.64.0711071931260.20249@fbirervta.pbzchgretzou.qr>
 <47320DFB.9000402@endian.com> <Pine.LNX.4.64.0711072026550.20249@fbirervta.pbzchgretzou.qr>
 <473216E9.1040309@endian.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37758 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbXKGUmY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 15:42:24 -0500
In-Reply-To: <473216E9.1040309@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 7 2007 20:50, Peter Warasin wrote:
>Jan Engelhardt wrote:
>> On Nov 7 2007 20:11, Peter Warasin wrote:
>>> If you want me to change it to --dry-run, i will do that, so i can use
>>> -t for --table.
>> 
>> be prepared to hear the 'that breaks compatibilty' argument.
>> Though, since it's 1.4.0, I'd go for it :p
>
>I imagine :)
>Ok, i will try.
>
>BTW: Is somewhere some sort of coding style documentation which i can
>read in order to prevent such mistakes, or is it just the linux kernel
>coding style?

LKCS is the preferred one, yes.

>Some of the malformed style you suggested to change are due to
>copy&paste of current iptables code, which i used as reference in some
>cases, so i am little confused now.

Yup, there is a lot of crufty code. Like what, less than 1% of all
active developers of a project care about styling. Unfortunately for
netfilter, 1% of N is generally less than 1.
