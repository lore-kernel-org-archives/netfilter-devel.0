From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Wed, 08 Jun 2011 20:14:38 +0100
Message-ID: <4DEFCA1E.1040404@googlemail.com>
References: <4DEDEB99.4070601@netfilter.org>	<4DEDFE43.5060402@googlemail.com>	<201106081049.48026.sgrubb@redhat.com>	<4DEFBBBE.6090307@schaufler-ca.com>	<BANLkTinjSiNc8VtxTntq7ekFtHrR2nq8EA@mail.gmail.com>	<4DEFC6C9.5030004@googlemail.com> <BANLkTikhbT7EVXcKM8vSHir=6Va+qWY19A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Casey Schaufler <casey@schaufler-ca.com>,
	Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
	Thomas Graf <tgraf@redhat.com>,
	netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Paris <eparis@parisplace.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34624 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1FHTOo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:14:44 -0400
Received: by wwa36 with SMTP id 36so912473wwa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2011 12:14:43 -0700 (PDT)
In-Reply-To: <BANLkTikhbT7EVXcKM8vSHir=6Va+qWY19A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> The LSM might report and error.  It's up to the caller to figure out
> how to deal with that error.  In this case we want to use the audit
> system so it's up to the audit system how to handle that error.  This
> helper function says the audit system should log it if it work and
> should audit_panic() if it doesn't.  audit_panic() will just call
> printk for most people and can actually panic the box for nutters who
> really care.  In this way we always log the information and if we
> don't it's up to audit how audit handles it's inability to log info.
>
> It's not netfilter's job to handle the error.  It's not the LSMs job
> to know how it's caller wants to handle the error.  Audit is who has
> special requirements and the code to handle the error should be in
> audit code.  (Maybe it wasn't clear, but I think this function should
> go in kernel/audit.c, not the netfilter code.  The netfilter code
> should call this helper function.
>   
Yeah, that's fair enough, though from what I remember 
security_secid_to_secctx already returns a 'yes'/'no' result (I am 
talking from the top of my head here as I am away at present and can't 
check it out to be certain), indicating whether the conversion was 
successful or not.

