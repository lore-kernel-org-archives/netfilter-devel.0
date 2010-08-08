From: Jan Engelhardt <jengelh@medozas.de>
Subject: RE: newbie: writing custom target, need help with getting it to
 work
Date: Sun, 8 Aug 2010 23:13:17 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008082312200.20773@obet.zrqbmnf.qr>
References: <00fe01cb3737$19358d20$4ba0a760$@com> <alpine.LSU.2.01.1008082225540.14264@obet.zrqbmnf.qr> <011101cb373d$f0b6b6b0$d2242410$@com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Yossi Weihs <yw@seafire.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58850 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab0HHVNS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Aug 2010 17:13:18 -0400
In-Reply-To: <011101cb373d$f0b6b6b0$d2242410$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-08-08 23:09, Yossi Weihs wrote:

>I have added the env variable, but saw no change.

Make sure that xt_TAP.ko is then actually loaded.

>going on? I know my module is calling xt_register_targets(), is there a 
>way for me to check the contents of its tables?

iptables -vvL

should print the semi-raw dump of the table before trying to resolve 
targets.
