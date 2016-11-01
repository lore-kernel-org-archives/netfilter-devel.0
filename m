From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 19/22] netfilter: ipset: use setup_timer() and
 mod_timer().
Date: Tue, 1 Nov 2016 20:28:27 +0100
Message-ID: <20161101192827.GK18827@salvia>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1477255075-15255-20-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754077AbcKAT2j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 15:28:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4907F168380
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:28:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 398DBBAC29
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:28:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D4B9BAC29
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:28:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477255075-15255-20-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 10:37:52PM +0200, Jozsef Kadlecsik wrote:
> From: Muhammad Falak R Wani <falakreyaz@gmail.com>
> 
> Use setup_timer() and instead of init_timer(), being the preferred way
> of setting up a timer.
> 
> Also, quoting the mod_timer() function comment:
> -> mod_timer() is a more efficient way to update the expire field of an
>    active timer (if the timer is inactive it will be activated).
> 
> Use setup_timer() and mod_timer() to setup and arm a timer, making the
> code compact and easier to read.

Please, merge 19/22, 20/22 and 21/22 into one single patch.

The description and the changeset is exactly the same, so there is no
need for three separated patches.

Thanks.
