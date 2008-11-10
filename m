From: Patrick McHardy <kaber@trash.net>
Subject: Re: libiptc: make sockfd a per-handle thing
Date: Mon, 10 Nov 2008 17:07:15 +0100
Message-ID: <49185C33.9090208@trash.net>
References: <alpine.LNX.1.10.0811060933060.26551@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811060934380.26551@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811060935020.26551@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811060935130.26551@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52200 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYKJQHZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:07:25 -0500
In-Reply-To: <alpine.LNX.1.10.0811060935130.26551@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 976ee346f58ae69ee82fcd750813d2b4fb7379b1
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Nov 6 09:23:06 2008 +0100
> 
> libiptc: make sockfd a per-handle thing

No objections in general, but I would like to see an explanation
of the impact the usage-counter removal has on things like
iptables-restore, that initialize the socket multiple times.
