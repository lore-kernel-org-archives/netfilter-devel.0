From: Paul Moore <paul@paul-moore.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Sat, 21 Jan 2017 12:37:50 -0500
Message-ID: <CAHC9VhQK67Mi-afj90irrv6h2d1XaiLKEYD0wr+j7JD4MmRTPg@mail.gmail.com>
References: <20170117052551.GQ3087@madcap2.tricolour.ca> <20170118151520.GY3087@madcap2.tricolour.ca>
 <CAHC9VhS_6Q=bxnzU8ni1a2fRWnXoMcELzAmy0HmwMH_xhgfRBw@mail.gmail.com>
 <21839828.eXAB1nqvpV@x2> <CAHC9VhT8QQ2inKgJ_ZAeiEOvmnjv-0AbHjrRf-LGfUT+WMFUeQ@mail.gmail.com>
 <e14df9b0-e6ea-c60f-f580-40b10af2392f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <pmoore@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Patrick PIGNOL <patrick.pignol@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:32967 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdAURhv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Jan 2017 12:37:51 -0500
Received: by mail-ua0-f172.google.com with SMTP id i68so84285352uad.0
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jan 2017 09:37:51 -0800 (PST)
In-Reply-To: <e14df9b0-e6ea-c60f-f580-40b10af2392f@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 21, 2017 at 6:27 AM, Patrick PIGNOL
<patrick.pignol@gmail.com> wrote:
> Hi all,
>
> I disagree !
>
> Many people in the world would like to allow an software A to go to internet
> through OUTPUT TCP port 80 but disallow software B to go to the internet
> through this same OUTPUT TCP port 80. Don't you know about viruses on linux
> ? Viruses ALWAYS use HTTP/HTTPS ports to get payloads on internet and OUTPUT
> TCP port 443 COULD NOT be CLOSED for ALL SOFTWARE if you want to access
> internet services (via internet browsers for example).

The Linux audit subsystem simply logs system events, it does not
enforce security policy.  I suggest you investigate the different
Linux firewall tools and LSMs, e.g. SELinux, as they should help you
accomplish what you describe.

-- 
paul moore
www.paul-moore.com
