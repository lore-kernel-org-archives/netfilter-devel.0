From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Thu, 16 Jun 2011 09:36:21 +0100
Message-ID: <4DF9C085.3040306@googlemail.com>
References: <4DEDEB99.4070601@netfilter.org>	<4DEFC6C9.5030004@googlemail.com>	<BANLkTikhbT7EVXcKM8vSHir=6Va+qWY19A@mail.gmail.com>	<201106081528.22926.sgrubb@redhat.com>	<BANLkTik9wXe+g4EXByUt3MrxGhuLKgTV3A@mail.gmail.com>	<4DF0BC5F.5040100@trash.net>	<BANLkTin-M-60LSTbvAdpzfio0suYj2WcqA@mail.gmail.com>	<4DF0D3C9.8030404@googlemail.com> <BANLkTim-d4bSqMKd_8Ef2gQCe37F1rY6dw@mail.gmail.com> <4DF0E3D3.1070002@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, Steve Grubb <sgrubb@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linux-audit@redhat.com, Thomas Graf <tgraf@redhat.com>,
	netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Paris <eparis@parisplace.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40664 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab1FPIgg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:36:36 -0400
Received: by wwa36 with SMTP id 36so1294062wwa.1
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2011 01:36:35 -0700 (PDT)
In-Reply-To: <4DF0E3D3.1070002@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>>> #ifdef CONFIG_NF_CONNTRACK_SECMARK
>>>   if (skb->secmark)
>>>               audit_log_secctx(ab,skb->secmark);
>>> #endif
>>>
>>> Thus, discarding the result (rc), unless we are interested in the error
>>> code, which I don't think is the case here. Would everyone be happy 
>>> with
>>> this?
>>>     
>>
>> Actually just make it a void function as I don't think anyone
>> would/could/should make use of the return value.
>>   
> In other words (audit.c) - N.B. the change from "subj" to "obj" as per 
> Steve's suggestion a while ago:
>
> void audit_log_secctx(struct auditbuffer *ab, u32 secid)
> {
>    int len;
>    char *ctx;
>
>    if (security_secid_to_secctx(sid, &ctx, &len)) {
>        audit_panic("Cannot convert secid to context");
>    } else {
>            audit_log_format(ab, " obj=%s", ctx);
>            security_release_secctx(ctx, len);
>    }
> }
>
> And xt_AUDIT.c stays as per my suggestion above. Should I assume that 
> gets the "go" from everyone concerned?
If there are no objections, I'll resubmit the patch at the weekend with 
the above functionality implemented.
