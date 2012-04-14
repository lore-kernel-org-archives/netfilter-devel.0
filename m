From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: xtables-addons link error
Date: Sat, 14 Apr 2012 15:59:53 +0100
Message-ID: <4F8990E9.9050701@googlemail.com>
References: <4F7BB331.7000808@googlemail.com> <alpine.LNX.2.01.1204050724100.6040@frira.zrqbmnf.qr> <4F7D7B8F.3000705@googlemail.com> <4F88E7D9.7000508@googlemail.com> <alpine.LNX.2.01.1204141007590.1110@frira.zrqbmnf.qr> <4F898CC0.6080806@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46331 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2DNO75 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Apr 2012 10:59:57 -0400
Received: by wejx9 with SMTP id x9so2490443wej.19
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Apr 2012 07:59:56 -0700 (PDT)
In-Reply-To: <4F898CC0.6080806@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Has this been attempted before - to include the xta modules as part of 
> the kernel? If there is an interest, I could dig in again to see what 
> other linking errors was I getting - just let me know.
Forgot to add - for two of the xta modules (don't remember which ones 
though) there were errors that these are already in the kernel, so 
perhaps a logic in their code/Makefile could be added to exclude 
themselves from building if a decent/recent version of the kernel exists.
