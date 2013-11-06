From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 3/4] build: avoid inclusion of stdbool.h in C++
Date: Wed, 6 Nov 2013 19:21:06 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1311061915230.29424@nerf07.vanv.qr>
References: <1382963240-18760-1-git-send-email-jengelh@inai.de> <1382963240-18760-4-git-send-email-jengelh@inai.de> <20131105125729.GC29010@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:48611 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab3KFSVM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:21:12 -0500
In-Reply-To: <20131105125729.GC29010@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2013-11-05 13:57, Pablo Neira Ayuso wrote:

>On Mon, Oct 28, 2013 at 01:27:19PM +0100, Jan Engelhardt wrote:
>> C++ does not need this header, as it already has bool builtin.
>
>This works fine with g++ as is at this moment.
>Do you plan to compile libnftables using a different compiler?

No such plans. I am indifferent to them, but some facts I collected:

<stdbool.h>/<cstdbool> is explicitly documented to be a GCC extension 
(which clang copies).
A side effect of stdbool.h is that the (C++) keywords "bool", "false" 
and "true" are turned into macros.
