From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH ulogd2] adjust ulogd.logrotate to match ulogd.conf
Date: Sun, 12 Feb 2017 15:09:00 +0100
Message-ID: <20170212140900.GA10250@salvia>
References: <20170203112427.22678-1-kaarle.ritvanen@datakunkku.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49916 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751206AbdBLOJK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Feb 2017 09:09:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7161996EC7
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 15:09:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 60EDBDA7FA
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 15:09:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE67DDA7F7
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 15:09:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170203112427.22678-1-kaarle.ritvanen@datakunkku.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'll let Eric decide to this small update.

On Fri, Feb 03, 2017 at 01:24:27PM +0200, Kaarle Ritvanen wrote:
> Signed-off-by: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
> ---
>  ulogd.logrotate | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ulogd.logrotate b/ulogd.logrotate
> index b3fb6d1..a865353 100644
> --- a/ulogd.logrotate
> +++ b/ulogd.logrotate
> @@ -1,4 +1,4 @@
> -/var/log/ulogd.log /var/log/ulogd.syslogemu /var/log/ulogd.pktlog /var/log/ulogd.pcap {
> +/var/log/ulogd*.log {
>      missingok
>      sharedscripts
>      postrotate
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
