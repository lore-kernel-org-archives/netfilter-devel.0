From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntracd init.d reload is broken on Centos6
Date: Thu, 16 Nov 2017 14:25:28 +0100
Message-ID: <20171116132528.GA2159@salvia>
References: <CAPyb0YcPtkruBLSVfxBnU1jrkL_5PgCxLvN56pMgexPHx=RZrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jason Hendry <jhendry@mintel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60688 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754009AbdKPNZe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 08:25:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 199F62E7846
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 14:25:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A44CDA876
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 14:25:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAPyb0YcPtkruBLSVfxBnU1jrkL_5PgCxLvN56pMgexPHx=RZrQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 16, 2017 at 10:47:15AM +0000, Jason Hendry wrote:
> Hi,
> 
> Was not sure where to send this so hoping this is the right place.  We
> am running Centos6 with conntrack-tools.  The reload option to the
> conntrackd init.d script does not work due to a syntax error on the
> killproc init function.
[...]
> Index: conntrackd
> ===================================================================
> --- conntrackd   (revision 46829)
> +++ conntrackd   (working copy)
> @@ -85,7 +85,7 @@
>  # XXX: can conntrackd reload?
>  reload() {
>          echo -n $"Reloading $prog configuration: "
> -        killproc -HUP $prog
> +        killproc $prog -HUP
>          retval=$?
>          echo
>          return $retval
> 
> 
> If you prefer this be submitted somewhere else or in a different
> format I am happy to do so.

I think you have to send this to the CentOS people, I don't see such
script on our git tree.

Thanks.
