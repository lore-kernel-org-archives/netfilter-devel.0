From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 2nd revision] Add SELinux context support to AUDIT target
Date: Tue, 07 Jun 2011 09:18:54 +0100
Message-ID: <4DEDDEEE.90509@googlemail.com>
References: <4DDE9194.4030303@netfilter.org> <4DD5BF5A.2030108@googlemail.com> <4DDE848F.1070508@netfilter.org> <4DDE87F5.9050606@googlemail.com> <4DEA4B44.8050809@googlemail.com> <4DEC0C01.4040900@netfilter.org> <4DECC1D9.7010605@googlemail.com> <4DED60B1.9080804@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@redhat.com>,
	Patrick McHardy <kaber@trash.net>,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux-audit <linux-audit@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40830 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab1FGITH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:19:07 -0400
Received: by wya21 with SMTP id 21so3363301wya.19
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jun 2011 01:19:05 -0700 (PDT)
In-Reply-To: <4DED60B1.9080804@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> Is this a style-type requirement I wasn't aware of? Because from a
>> syntax point of view the left/right braces aren't necessary.
>>     
>
> Aware of it, it's just coding style.
>   
Thanks for pointing it out (now I know)! Would you like me to resubmit 
the patch with the 2 braces included or are you happy with what I have 
provided?
