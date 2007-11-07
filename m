From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/3] iptables-edit: iptables-edit: adds --table to
 iptables-restore
Date: Wed, 7 Nov 2007 20:27:31 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711072026550.20249@fbirervta.pbzchgretzou.qr>
References: <472E6041.7090601@endian.com> <Pine.LNX.4.64.0711071150390.1982@fbirervta.pbzchgretzou.qr>
 <4731C14F.50607@endian.com> <Pine.LNX.4.64.0711071737520.20249@fbirervta.pbzchgretzou.qr>
 <473200BD.10803@endian.com> <Pine.LNX.4.64.0711071931260.20249@fbirervta.pbzchgretzou.qr>
 <47320DFB.9000402@endian.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54035 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbXKGT1c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:27:32 -0500
In-Reply-To: <47320DFB.9000402@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 7 2007 20:11, Peter Warasin wrote:
>> That said, iptables-restore does not have a -t, according to its help text
>> ("iptables-restore -h") and its manpage.
>
>Thats not true. The current subversion code uses -t for --test. Probably
>you confuse with iptables-save ?

actually, overlooked it :-/

>If you want me to change it to --dry-run, i will do that, so i can use
>-t for --table.

be prepared to hear the 'that breaks compatibilty' argument.
Though, since it's 1.4.0, I'd go for it :p
