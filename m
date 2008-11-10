From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: libiptc: make sockfd a per-handle thing
Date: Mon, 10 Nov 2008 17:24:27 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811101722550.22110@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0811060933060.26551@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811060934380.26551@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811060935020.26551@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811060935130.26551@fbirervta.pbzchgretzou.qr>
 <49185C33.9090208@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40552 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbYKJQY2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:24:28 -0500
In-Reply-To: <49185C33.9090208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-11-10 17:07, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>> commit 976ee346f58ae69ee82fcd750813d2b4fb7379b1
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Thu Nov 6 09:23:06 2008 +0100
>> 
>> libiptc: make sockfd a per-handle thing
>
> No objections in general, but I would like to see an explanation
> of the impact the usage-counter removal has on things like
> iptables-restore, that initialize the socket multiple times.

None, because iptc_commit closes the socket --
so that iptables-restore opened the socket once for each table
anew anyway. (You can look for this with
`strace -e socket iptables-restore`.)
