From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH v2] conntrackd: make the daemon run in RT
 mode by default
Date: Mon, 12 Jun 2017 11:24:36 +0200
Message-ID: <20170612092436.GA5500@salvia>
References: <149725643738.6842.5325404856389402790.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:56896 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752158AbdFLJY4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2017 05:24:56 -0400
Content-Disposition: inline
In-Reply-To: <149725643738.6842.5325404856389402790.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 12, 2017 at 10:34:35AM +0200, Arturo Borrero Gonzalez wrote:
> In order to prevent netlink buffer overrun, conntrackd is recommended to run
> at max priority.
> Make conntrackd to use a RT (SHED_RR) scheduler by default at max priority.
> This is common among other HA daemons. For example corosync uses SCHED_RR
> by default.
> The scheduler configuration option is kept in order to allow admins to perform
> fine-tuning, but it is deleted from example configuration files.
> 
> Note that this default sched priority is so high that it makes the nice value
> useless, so deprecate the nice configuration. Anyway the nice value can be set
> externally at runtime using nice/renice.
> 
> The code is moved to the init() routine. In case of error setting the
> scheduler, the system default will be used. Report a message to the user
> and continue working.

Applied, thanks Arturo.
