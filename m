From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/3] iptables-edit: iptables-edit: adds --table to
 iptables-restore
Date: Wed, 7 Nov 2007 19:34:27 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711071931260.20249@fbirervta.pbzchgretzou.qr>
References: <472E6041.7090601@endian.com> <Pine.LNX.4.64.0711071150390.1982@fbirervta.pbzchgretzou.qr>
 <4731C14F.50607@endian.com> <Pine.LNX.4.64.0711071737520.20249@fbirervta.pbzchgretzou.qr>
 <473200BD.10803@endian.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34124 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbXKGSe2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:34:28 -0500
In-Reply-To: <473200BD.10803@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 7 2007 19:15, Peter Warasin wrote:
>
>> Is a dry-run option really needed? iptables-edit does not commit
>
>Attention, this is a new option of iptables-restore, not of iptables-edit.
>--test was already implemented within iptables-restore.
>So in order to use -t instead of -T it's necessary to rename --test to
>for example --dry-run

-t means table for:
	iptables
	iptables-save
	ip6tables
	ip6tables-save
	arptables
	ebtables

iptables-restore having -t for test really seems out of place.

That said, iptables-restore does not have a -t, according to its help text
("iptables-restore -h") and its manpage.
