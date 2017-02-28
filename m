From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 1/2] xshared: do not lock again and again if
 "-w" option is not specified
Date: Tue, 28 Feb 2017 12:18:00 +0100
Message-ID: <20170228111800.GA17105@salvia>
References: <1486303055-11891-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, subashab@codeaurora.org,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52842 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbdB1LTD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 06:19:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E5D232D15F5
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:18:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D80C8DA849
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:18:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5AB2BDA847
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:18:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1486303055-11891-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 05, 2017 at 09:57:34PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> After running the following commands, some confusing messages was printed
> out:
>   # while : ; do
>   iptables -A INPUT &
>   iptables -D INPUT &
>   done
>   [...]
>   Another app is currently holding the xtables lock; still -9s 0us time
>   ahead to have a chance to grab the lock...
>   Another app is currently holding the xtables lock; still -29s 0us time
>   ahead to have a chance to grab the lock...
> 
> If "-w" option is not specified, the "wait" will be zero, so we should
> check whether the timer_left is less than wait_interval before we call
> select to sleep.
> 
> Also remove unused "BASE_MICROSECONDS" and "struct timeval waited_time"
> introduced by commit e8f857a5a151 ("xtables: Add an interval option for
> xtables lock wait").

Applied, thanks.
