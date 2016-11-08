From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 1/3] log: introduce a mechanism to know
 if log was initialized
Date: Wed, 9 Nov 2016 00:30:04 +0100
Message-ID: <20161108233004.GA10359@salvia>
References: <147825582201.31164.6123720868667079634.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34988 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752070AbcKHXaz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 18:30:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0208C8D0502
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:30:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3C8FDA80B
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:30:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF26CDA80B
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:30:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <147825582201.31164.6123720868667079634.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 04, 2016 at 11:37:02AM +0100, Arturo Borrero Gonzalez wrote:
> This will allow to call dlog() function from all the points in the
> execution at runtime.
> 
> If the log was not initialized, then we just fprintf and return.
> 
> By now, we can't init the log engine earlier because we require config
> from the user, so there is a egg-chicken problem.
> This means that we can't log parsing messages to logfiles but only to
> stderr/stdout.

Series applied, thanks Arturo.

A couple of things that would be good to revisit, just for the record:

1) Get rid of deprecated stuff. By digging into the git log history I
   guess you can probably find that they have been deprecated since
   ~2008, so it's been already enough time for people to update
   configuration files.

2) Make sure the configuration parser works fine with defaults, I mean
   with the bare minimum configuration. I remember reports from people
   that wrote configuration files from scratch, that were not working.
   So I pointed them to the example files to use as template.

Thanks.
