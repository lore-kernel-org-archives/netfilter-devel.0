From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ulogd2 PATCH] ulogd2: add new config option: load_all_plugins
Date: Fri, 29 Sep 2017 13:39:49 +0200
Message-ID: <20170929113949.GA28566@salvia>
References: <150633836700.6370.2675458398740561976.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [213.95.27.120] ([213.95.27.120]:59652 "EHLO
        ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbdI2LlD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2017 07:41:03 -0400
Content-Disposition: inline
In-Reply-To: <150633836700.6370.2675458398740561976.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Mon, Sep 25, 2017 at 01:19:27PM +0200, Arturo Borrero Gonzalez wrote:
> diff --git a/ulogd.conf.in b/ulogd.conf.in
> index a987d64..fe54420 100644
> --- a/ulogd.conf.in
> +++ b/ulogd.conf.in
> @@ -24,6 +24,16 @@ logfile="/var/log/ulogd.log"
>  # 2. options for each plugin in seperate section below
>  
>  
> +# load all the plugins in one go. Then, there is no need to specify each
> +# plugin individually. There are two ways of using this clause, by leaving it
> +# blank (default) or by using a filesystem path. If blank a default directory
> +# configured at build time will be used (--with-ulogd2libdir).
> +#
> +# Examples:
> +#
> +# load_all_plugins=
> +# load_all_plugins=/usr/local/lib/ulogd/
> +
>  plugin="@pkglibdir@/ulogd_inppkt_NFLOG.so"
>  #plugin="@pkglibdir@/ulogd_inppkt_ULOG.so"
>  #plugin="@pkglibdir@/ulogd_inppkt_UNIXSOCK.so"

Just an idea, probably better something like:

        plugin="@pkglibdir@/"

I mean, if you specify a directory, then this means "include every
ulogd_*.so file there", it's easy to check via stat() if this is path
represents a directory, so you can skip string handling tricks.

Thanks.
