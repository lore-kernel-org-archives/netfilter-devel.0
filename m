From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 2nd revision] Add SELinux context support to AUDIT target
Date: Mon, 06 Jun 2011 13:42:15 +0100
Message-ID: <4DECCB27.6040706@googlemail.com>
References: <4DDE9194.4030303@netfilter.org> <201106060814.12524.sgrubb@redhat.com> <4DECC754.6040003@googlemail.com> <201106060830.52644.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
	Thomas Graf <tgraf@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Paris <eparis@parisplace.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37763 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab1FFMm0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:42:26 -0400
Received: by wya21 with SMTP id 21so2749356wya.19
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jun 2011 05:42:25 -0700 (PDT)
In-Reply-To: <201106060830.52644.sgrubb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> This is not any more leak than leaking the context string to user space as this patch 
> attempts to do. The rest of the audit code does log the numeric representation when 
> text fails.
>   
There is no "leak" when the secctx is recorded in the audit log - it is 
supposed to be there, if present (and retrievable). As for exposing the 
(internal) numerical representation of the secctx - this was discussed 
previously and the approach you are suggesting was dropped. To quote 
Eric on this very issue "[It] exports the internal secid to userspace. 
These are dynamic, can change on lsm changes, and have no meaning in 
userspace. We should instead be sending lsm contexts to userspace instead.".

