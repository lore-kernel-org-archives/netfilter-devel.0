From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] Fix adding an IPv4 range containing more than 2^31
 addresses
Date: Tue, 26 Sep 2017 20:01:36 +0200
Message-ID: <20170926180136.GA24950@salvia>
References: <1506202660-12553-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1506202660-12553-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:56187 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968988AbdIZSBk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2017 14:01:40 -0400
Content-Disposition: inline
In-Reply-To: <1506202660-12553-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 23, 2017 at 11:37:40PM +0200, Jozsef Kadlecsik wrote:
> Wrong comparison prevented the hash types to add a range with
> more than 2^31 addresses but reported as a success.
> 
> Fixes bugzilla id #1005, reported by Oleg Serditov and Oliver Ford.

Applied, thanks Jozsef.

Jozsef, I'm prepending the following to this patch title: "netfilter: ipset:"
