From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 2nd revision] Add SELinux context support to AUDIT target
Date: Mon, 06 Jun 2011 13:25:56 +0100
Message-ID: <4DECC754.6040003@googlemail.com>
References: <4DDE9194.4030303@netfilter.org> <4DDE87F5.9050606@googlemail.com> <4DEA4B44.8050809@googlemail.com> <201106060814.12524.sgrubb@redhat.com>
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
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39786 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab1FFM0H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:26:07 -0400
Received: by wwa36 with SMTP id 36so3738805wwa.1
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jun 2011 05:26:06 -0700 (PDT)
In-Reply-To: <201106060814.12524.sgrubb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Normally there would be an else here to do something like
> audit_log_format(ab, " osid=%u", skb->secmark);
> so that its recorded numerically if the context could not be looked up.
>   
I disagree! That approach was dropped long ago when the secctx was first 
introduced to prevent kernel information leaking into userspace (Eric 
would know more about this as he designed that aspect of it a couple of 
months ago). So the secctx is either present (and retrievable!) or not 
present from the (xt_)audit point of view. For more information see 
net/netfilter/nf_conntrack_standalone.c in the current nf-next tree.

In other words, no else is necessary.

