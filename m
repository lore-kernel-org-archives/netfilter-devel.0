From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 nf-next 1/7] netfilter: don't rely on DYING bit to
 detect when destroy event was sent
Date: Wed, 24 Aug 2016 10:05:28 -0700
Message-ID: <1472058328.14381.96.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1472039755-14267-1-git-send-email-fw@strlen.de>
         <1472039755-14267-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35788 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932286AbcHXRFb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 13:05:31 -0400
Received: by mail-pf0-f195.google.com with SMTP id h186so1538511pfg.2
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 10:05:31 -0700 (PDT)
In-Reply-To: <1472039755-14267-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2016-08-24 at 13:55 +0200, Florian Westphal wrote:
> The reliable event delivery mode currently (ab)uses the DYING bit to
> detect which entries on the dying list have to be skipped when
> re-delivering events from the eache worker in reliable event mode.
> 
> Currently when we delete the conntrack from main table we only set this
> bit if we could also deliver the netlink destroy event to userspace.
> 
> If we fail we move it to the dying list, the ecache worker will
> reattempt event delivery for all confirmed conntracks on the dying list
> that do not have the DYING bit set.
> 
> Once timer is gone, we can no longer use if (del_timer()) to detect
> when we 'stole' the reference count owned by the timer/hash entry, so
> we need some other way to avoid racing with other cpu.
> 
> Pablo suggested to add a marker in the ecache extension that skips

Acked-by: Eric Dumazet <edumazet@google.com>


