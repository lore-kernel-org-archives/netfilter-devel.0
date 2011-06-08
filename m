From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Wed, 08 Jun 2011 19:45:12 +0100
Message-ID: <4DEFC338.3070908@googlemail.com>
References: <4DEDEB99.4070601@netfilter.org> <201106081049.48026.sgrubb@redhat.com> <4DEFBBBE.6090307@schaufler-ca.com> <201106081436.38509.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-audit@redhat.com,
	Thomas Graf <tgraf@redhat.com>,
	netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Eric Paris <eparis@parisplace.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63826 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1FHSpS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 14:45:18 -0400
Received: by wwa36 with SMTP id 36so888099wwa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2011 11:45:17 -0700 (PDT)
In-Reply-To: <201106081436.38509.sgrubb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> how is this error preserved in the audit trail?
>   
Look at my patch again - if the secctx cannot be retrieved, either 
because a) it does not exists; or b) because of internal error or 
otherwise, then it is not logged in the audit log as part of the 
NETFILTER_PKT message (the fact there is internal LSM error has 
absolutely nothing to do with a netfilter packet!).

If, internally (upon calling security_secid_to_secctx) there is a 
decision to handle that *internal* error in one way or another so be it, 
but as far as my patch goes - there is no secctx if that function 
returns nothing and I think that is the right think to do.

