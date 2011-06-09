From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Thu, 09 Jun 2011 15:08:09 +0100
Message-ID: <4DF0D3C9.8030404@googlemail.com>
References: <4DEDEB99.4070601@netfilter.org>	<4DEFC6C9.5030004@googlemail.com>	<BANLkTikhbT7EVXcKM8vSHir=6Va+qWY19A@mail.gmail.com>	<201106081528.22926.sgrubb@redhat.com>	<BANLkTik9wXe+g4EXByUt3MrxGhuLKgTV3A@mail.gmail.com>	<4DF0BC5F.5040100@trash.net> <BANLkTin-M-60LSTbvAdpzfio0suYj2WcqA@mail.gmail.com>
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
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54635 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1FIOIO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:08:14 -0400
Received: by wwa36 with SMTP id 36so1737897wwa.1
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2011 07:08:13 -0700 (PDT)
In-Reply-To: <BANLkTin-M-60LSTbvAdpzfio0suYj2WcqA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> Just to make sure, so the conclusion is that the patch is fine as
>> it is and anything related to unconvertible secids will be handled
>> by SELinux internally?
>>
>>     
>
> No.  This patch does not get my ACK.  Steve is right that silently
> dropping information is a big big no no for the audit system and
> that's what this patch does.  This cannot be wholly handled properly
> inside the LSM either.  I don't see any patch meeting everyone's
> requirements outside of a new one that includes the audit helper I
> suggested.
>   
Right, so the function you suggested yesterday (audit_log_secctx) should 
be added in audit.c in its entirety, and xt_AUDIT.c should just have 
something like:

#ifdef CONFIG_NF_CONNTRACK_SECMARK
    if (skb->secmark)
                audit_log_secctx(ab,skb->secmark);
#endif

Thus, discarding the result (rc), unless we are interested in the error 
code, which I don't think is the case here. Would everyone be happy with 
this?
