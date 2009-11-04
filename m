From: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
Subject: AW: Problem with ipset on sparc64
Date: Wed, 4 Nov 2009 21:50:18 +0000
Message-ID: <4513233BE7DF454BB62D30017EEE55436CFB9228E4@GVW1115EXC.americas.hpqcorp.net>
References: <alpine.LSU.2.00.0911042219050.13080@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:36321 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967AbZKDVvD convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:51:03 -0500
In-Reply-To: <alpine.LSU.2.00.0911042219050.13080@obet.zrqbmnf.qr>
Content-Language: de-DE
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>
>I'm using ipset 3.2 on a sparc64 system (ultra2), kernel 2.6.31.5, Debian 5.
>Everything works fine, but the -L option shows strange values for a portmap.


If you explicitly compile ipset as a 64-bit program rather than the
32-bit default that is used on sparc, will the correct values be
shown?

Thanks for the fast reply. I added -m64 to cc and ld options and
recompiled. Is that correct? If yes, I now get a bus error instead
of a wrong listing. Or do I have to change anything else?
