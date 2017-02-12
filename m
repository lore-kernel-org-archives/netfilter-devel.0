From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH ulogd2] adjust ulogd.logrotate to match ulogd.conf
Date: Sun, 12 Feb 2017 16:49:41 +0100
Message-ID: <1486914581.10972.3.camel@regit.org>
References: <20170203112427.22678-1-kaarle.ritvanen@datakunkku.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:40873 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751226AbdBLPto (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Feb 2017 10:49:44 -0500
In-Reply-To: <20170203112427.22678-1-kaarle.ritvanen@datakunkku.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Fri, 2017-02-03 at 13:24 +0200, Kaarle Ritvanen wrote:
> Signed-off-by: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
> ---
>  ulogd.logrotate | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ulogd.logrotate b/ulogd.logrotate
> index b3fb6d1..a865353 100644
> --- a/ulogd.logrotate
> +++ b/ulogd.logrotate
> @@ -1,4 +1,4 @@
> -/var/log/ulogd.log /var/log/ulogd.syslogemu /var/log/ulogd.pktlog 

This is not correct. All the listed files are default value for various
existing output modules so we should keep them.

> /var/log/ulogd.pcap {
> +/var/log/ulogd*.log {
>      missingok
>      sharedscripts
>      postrotate

PS to Kaarle: resending because initial mail did not reach the ML.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
