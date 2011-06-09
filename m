From: Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Thu, 9 Jun 2011 11:06:05 -0400
Message-ID: <BANLkTim-d4bSqMKd_8Ef2gQCe37F1rY6dw@mail.gmail.com>
References: <4DEDEB99.4070601@netfilter.org>
	<4DEFC6C9.5030004@googlemail.com>
	<BANLkTikhbT7EVXcKM8vSHir=6Va+qWY19A@mail.gmail.com>
	<201106081528.22926.sgrubb@redhat.com>
	<BANLkTik9wXe+g4EXByUt3MrxGhuLKgTV3A@mail.gmail.com>
	<4DF0BC5F.5040100@trash.net>
	<BANLkTin-M-60LSTbvAdpzfio0suYj2WcqA@mail.gmail.com>
	<4DF0D3C9.8030404@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, Steve Grubb <sgrubb@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linux-audit@redhat.com, Thomas Graf <tgraf@redhat.com>,
	netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55544 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1FIPGH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:06:07 -0400
Received: by iyb14 with SMTP id 14so1380452iyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2011 08:06:05 -0700 (PDT)
In-Reply-To: <4DF0D3C9.8030404@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 9, 2011 at 10:08 AM, Mr Dash Four
<mr.dash.four@googlemail.com> wrote:
>
>>> Just to make sure, so the conclusion is that the patch is fine as
>>> it is and anything related to unconvertible secids will be handled
>>> by SELinux internally?
>>>
>>>
>>
>> No. =A0This patch does not get my ACK. =A0Steve is right that silent=
ly
>> dropping information is a big big no no for the audit system and
>> that's what this patch does. =A0This cannot be wholly handled proper=
ly
>> inside the LSM either. =A0I don't see any patch meeting everyone's
>> requirements outside of a new one that includes the audit helper I
>> suggested.
>>
>
> Right, so the function you suggested yesterday (audit_log_secctx) sho=
uld be
> added in audit.c in its entirety, and xt_AUDIT.c should just have som=
ething
> like:
>
> #ifdef CONFIG_NF_CONNTRACK_SECMARK
> =A0 if (skb->secmark)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 audit_log_secctx(ab,skb->secmark);
> #endif
>
> Thus, discarding the result (rc), unless we are interested in the err=
or
> code, which I don't think is the case here. Would everyone be happy w=
ith
> this?

Actually just make it a void function as I don't think anyone
would/could/should make use of the return value.

-Eric
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
