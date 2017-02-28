From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables V2 2/2] xshared: using the blocking file lock
 request when we wait indefinitely
Date: Tue, 28 Feb 2017 12:18:12 +0100
Message-ID: <20170228111812.GB17105@salvia>
References: <1486381667-32577-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52940 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751341AbdB1LTD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 06:19:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EDAE02D15FF
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:18:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF657DA851
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:18:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A43E5DA84A
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:18:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1486381667-32577-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 06, 2017 at 07:47:47PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> When using "-w" to avoid concurrent instances, we try to do flock() every
> one second until it success. But one second maybe too long in some
> situations, and it's hard to select a suitable interval time. So when
> using "iptables -w" to wait indefinitely, it's better to block until
> it become success.
> 
> Now do some performance tests. First, flush all the iptables rules in
> filter table, and run "iptables -w -S" endlessly:
>   # iptables -F
>   # iptables -X
>   # while : ; do
>   iptables -w -S >&- &
>   done
> 
> Second, after adding and deleting the iptables rules 100 times, measure
> the time cost:
>   # time for i in $(seq 100); do
>   iptables -w -A INPUT
>   iptables -w -D INPUT
>   done
> 
> Before this patch:
>   real  1m15.962s
>   user  0m0.224s
>   sys   0m1.475s
> 
> Apply this patch:
>   real  0m1.830s
>   user  0m0.168s
>   sys   0m1.130s

Also applied, thanks.
