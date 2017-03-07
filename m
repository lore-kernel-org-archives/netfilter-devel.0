From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH ulogd2 1/2] ulogd.conf: harmonize log file options with
 module default values
Date: Tue, 07 Mar 2017 16:00:02 +0200
Message-ID: <1488895202.4890.4.camel@regit.org>
References: <20170213094729.23478-1-kaarle.ritvanen@datakunkku.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:38319 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755246AbdCGOWz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 09:22:55 -0500
In-Reply-To: <20170213094729.23478-1-kaarle.ritvanen@datakunkku.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Kaarle,

Thanks for the cleaning work. Some comment inside.

On Mon, 2017-02-13 at 11:47 +0200, Kaarle Ritvanen wrote:
> Signed-off-by: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
> ---
>  ulogd.conf.in | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/ulogd.conf.in b/ulogd.conf.in
> index 2fcf39a..6e7bdf4 100644
> --- a/ulogd.conf.in
> +++ b/ulogd.conf.in
> @@ -183,15 +183,15 @@ nlgroup=1
>  socket_path="/tmp/nuauth_ulogd2.sock"
>  
>  [emu1]
> -file="/var/log/ulogd_syslogemu.log"
> +file="/var/log/ulogd.syslogemu"

I really like the idea of getting an harmonized naming for the log
files but I think we should do it reverse for values that are not
commented in the configuration file. Most distributions and install are
shipping with a copy of default configuration. 

Most users won't have changed the values that are uncommented. So they
will have on disk the log file with name defined in the configuration
file. And they will benefit from a new logrotate file. Thus we should
use the file name defined in the conf as value of the default file name
in code.

Could you resubmit a patchset ?

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
