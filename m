From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next 0/2] netfilter: untracked object removal
Date: Wed, 08 Mar 2017 08:29:54 -0800
Message-ID: <1488990594.28631.2.camel@edumazet-glaptop3.roam.corp.google.com>
References: <20170308124950.9369-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:36167 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751309AbdCHQi0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 11:38:26 -0500
Received: by mail-pg0-f52.google.com with SMTP id 187so14987260pgb.3
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Mar 2017 08:38:25 -0800 (PST)
In-Reply-To: <20170308124950.9369-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2017-03-08 at 13:49 +0100, Florian Westphal wrote:
> These patches remove the percpu untracked objects, they get replaced
> with a new (kernel internal) ctinfo state.
> 
> This avoids reference counter operations for untracked packets and
> removes the need to check a conntrack for the UNTRACKED status bit
> before setting connmark, labels, etc.
> 
> I checked with following rule set and things appear to work as
> expected (i.e., ssh connections don't show up in conntrack -L):
> 
> *raw
> :PREROUTING ACCEPT [455:34825]
> :OUTPUT ACCEPT [251:29555]
> [775:63699] -A PREROUTING -p tcp -m tcp --dport 22 -j NOTRACK
> [251:29555] -A OUTPUT -p tcp -m tcp --sport 22 -j NOTRACK
> COMMIT
> *filter
> :INPUT ACCEPT [0:0]
> :FORWARD ACCEPT [0:0]
> :OUTPUT ACCEPT [0:0]
> [0:0] -A INPUT -m conntrack --ctstate INVALID -j DROP
> [337:26377] -A INPUT -p tcp -m conntrack --ctstate UNTRACKED -m tcp --dport 22 -j ACCEPT
> [0:0] -A INPUT -m conntrack --ctstate UNTRACKED
> [102:13883] -A OUTPUT -p tcp -m conntrack --ctstate UNTRACKED -m tcp --sport 22 -j ACCEPT
> [0:0] -A OUTPUT -m conntrack --ctstate UNTRACKED
> COMMIT


Very nice series Florian, thanks !



