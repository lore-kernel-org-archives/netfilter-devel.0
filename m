From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2] Improve security for xt_SYSRQ
Date: Sat, 25 Jun 2011 00:04:59 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106250004520.16290@frira.zrqbmnf.qr>
References: <cover.1308920081.git.john.haxby@oracle.com> <d6a29877862bfd3c3e47ac592d308cbce065a918.1308920081.git.john.haxby@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, prarit@redhat.com
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:46047 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab1FXWFB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jun 2011 18:05:01 -0400
In-Reply-To: <d6a29877862bfd3c3e47ac592d308cbce065a918.1308920081.git.john.haxby@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-06-24 15:14, John Haxby wrote:

>The xt_SYSRQ hash now includes the destination IPv4 or IPv6 address
>which makes it harder to replay a request to many different machines
>in the hope that some of them are using the same password.

Taken.
