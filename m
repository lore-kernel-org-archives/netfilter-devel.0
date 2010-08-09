From: Jan Engelhardt <jengelh@medozas.de>
Subject: RE: newbie: writing custom target, need help with getting it to
 work
Date: Mon, 9 Aug 2010 08:52:36 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008090852080.31937@obet.zrqbmnf.qr>
References: <00fe01cb3737$19358d20$4ba0a760$@com> <alpine.LSU.2.01.1008082225540.14264@obet.zrqbmnf.qr> <011101cb373d$f0b6b6b0$d2242410$@com> <alpine.LSU.2.01.1008082312200.20773@obet.zrqbmnf.qr> <013501cb377a$a04e60a0$e0eb21e0$@com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Yossi Weihs <yw@seafire.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45950 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab0HIGwk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:52:40 -0400
In-Reply-To: <013501cb377a$a04e60a0$e0eb21e0$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-08-09 06:23, Yossi Weihs wrote:

>OK - xt_TAP.ko is not getting loaded by iptables. I can modprobe it
>manually, but iptables won't load it. Trying telling iptables which modprobe
>to use, but no luck. xt_TEE.ko is getting loaded fine, and I cloned my
>module off it ... I feel we're getting close.

iptables just calls modprobe. And modprobe only looks in /lib/modules.

