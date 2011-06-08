From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Wed, 08 Jun 2011 20:00:25 +0100
Message-ID: <4DEFC6C9.5030004@googlemail.com>
References: <4DEDEB99.4070601@netfilter.org>	<4DEDFE43.5060402@googlemail.com>	<201106081049.48026.sgrubb@redhat.com>	<4DEFBBBE.6090307@schaufler-ca.com> <BANLkTinjSiNc8VtxTntq7ekFtHrR2nq8EA@mail.gmail.com>
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
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40022 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1FHTAa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:00:30 -0400
Received: by wya21 with SMTP id 21so599812wya.19
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2011 12:00:29 -0700 (PDT)
In-Reply-To: <BANLkTinjSiNc8VtxTntq7ekFtHrR2nq8EA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> int audit_log_secctx(struct auditbuffer *ab, u32 secid)
> {
>     int len, rc;
>     char *ctx;
>
>     rc = security_secid_to_secctx(sid, &ctx, &len);
>     if (rc) {
>         audit_panic("Cannot convert secid to context");
>     } else {
>             audit_log_format(ab, " subj=%s", ctx);
>             security_release_secctx(ctx, len);
>     }
>     return rc;
> }
>
> Such a function could be used a couple of places in the audit code itself.
>   
My view on this is that LSM error-handling should be part of LSM.

I presume security_secid_to_secctx is going to be called from quite a 
few places (well, I know of at least two now and they have nothing to do 
with the LSM) and in my opinion it would be better if that error 
handling, if adopted, is implemented within the function itself - 
whether by calling another function, like the one you proposed above, or 
as part of the secctx retrieval - this could be open to interpretation, 
but the point I am trying to make is that whichever code 
security_secid_to_secctx is invoked from shouldn't be involved in 
reporting/handling (internal LSM) errors at all.

I think I made that point in my previous post, but just wanted to make 
sure that is the case.

