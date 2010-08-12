From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ipset-4.2 compilation fails with recent kernel
Date: Thu, 12 Aug 2010 12:02:04 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008121157370.31027@obet.zrqbmnf.qr>
References: <AANLkTi=cY4pJpVELPg9Pfjf=HB8kaWHDUuuWrtT1DJ8Y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Nort Obor <obornort@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35941 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab0HLKCI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Aug 2010 06:02:08 -0400
In-Reply-To: <AANLkTi=cY4pJpVELPg9Pfjf=HB8kaWHDUuuWrtT1DJ8Y@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-08-12 07:31, Nort Obor wrote:

>hi,
>
>trying to compile ipset-4.2 / linux-2.6.35 with gcc-4.5.1, i get:
>
>...
>make[1]: Entering directory `/usr/src/linux-2.6.35'
>  CC [M]  /usr/src/ipset/kernel/ip_set.o
>  CC [M]  /usr/src/ipset/kernel/ipt_set.o
>/usr/src/ipset/kernel/ipt_set.c:89:20: warning: 'struct
>xt_match_param' declared inside parameter list

"Known issue", so to speak. Joszef has not updated the pristine ipset 
package yet, though you can use Xtables-addons, where 2.6.35 support has 
been added on May 16 already.

