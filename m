From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH v2] log: print messages to stdout/sderr
 if running in console mode
Date: Fri, 28 Oct 2016 10:16:49 +0200
Message-ID: <20161028081649.GA4009@salvia>
References: <147763774551.12311.7353846218834006990.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56556 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753117AbcJ1IQ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 04:16:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B39C762D20
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 10:16:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3C5DB7FEA
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 10:16:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8408BB7FEE
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 10:16:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <147763774551.12311.7353846218834006990.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 28, 2016 at 08:57:08AM +0200, Arturo Borrero Gonzalez wrote:
> If conntrackd is running in console mode (i.e. in foreground)
> then we can print the log messages to stdout/stderr.
> 
> This eases the workflow for admins, since we condensate more info into
> the same terminal output.

Applied, thanks Arturo.

BTW, one comment:

> Example:
> 
> % sudo conntrackd -C /etc/conntrackd.conf
> WARNING: XXXX is an invalid interface

Probably, we can now place this message via logging. I remember the
problem is that logging is not yet initialized at that stage, but this
should be easy to fix.

> [Thu Oct 27 13:57:09 2016] (pid=7581) [notice] disabling internal cache
> [Thu Oct 27 13:57:09 2016] (pid=7581) [notice] disabling external cache
> [Thu Oct 27 13:57:09 2016] (pid=7581) [ERROR] can't open channel socket: No such device
> [Thu Oct 27 13:57:09 2016] (pid=7581) [ERROR] initialization failed
> ERROR: conntrackd cannot start, please check the logfile for more info

And I guess this "ERROR: conntrackd cannot start, please review your
configuration" can go into log message too.
