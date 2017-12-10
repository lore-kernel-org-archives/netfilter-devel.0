From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_defrag_ipv4: Skip defrag if
 NOTRACK is set
Date: Sun, 10 Dec 2017 15:53:55 +0100
Message-ID: <20171210145355.GA24947@salvia>
References: <1510623446-9115-1-git-send-email-subashab@codeaurora.org>
 <20171209151018.GA5551@salvia>
 <dd0bf36c855a8e2ea41039f2282fb9ff@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        kadlec@blackhole.kfki.hu
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45508 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751616AbdLJOyB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Dec 2017 09:54:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5E3971BCFC4
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 15:53:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4EA45DA843
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 15:53:59 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <dd0bf36c855a8e2ea41039f2282fb9ff@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 09, 2017 at 07:06:14PM -0700, Subash Abhinov Kasiviswanathan wrote:
> >Would it work for you if this is specific via global modparam? I'm
> >telling this because:
> >
> >1) This is changing the default behaviour, which is always tricky.
> >2) This is already solved in nftables, so whatever solution that we
> >   apply, it should be iptables specific.
> >
> >If modparam is fine, just placing a line into
> >/etc/modprobe.d/options.conf (or similar) should be good enough to
> >store that you're requesting raw hook registration before defrag.
> >
> >Let me know,
> >Thanks!
> 
> Hi Pablo
> 
> Can you explain a bit more about the /etc/modprobe.d/ option and how
> it would be configured for this? /etc/modprobe.d/ doesnt exist on
> Android based Linux systems so it might be a problem for me.
> 
> Would it be an acceptable solution to create a kernel config for this
> particular feature instead?

I'm actually refering to module_param(), that is specified at modprobe
time. Such parameter would set an alternative hook priority for the
raw table, ie. before the defrag hook. I guess there must be a way to
store these module parameters in Android, so whenever modprobe is
invoked, either explicitly or via module autoload, this module
parameter is passed to the iptable_raw module.
