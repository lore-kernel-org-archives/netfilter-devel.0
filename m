Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F19C4332B
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Feb 2021 03:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8021764F95
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Feb 2021 03:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhBFDCs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:02:48 -0500
Received: from correo.us.es ([193.147.175.20]:48938 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231708AbhBFCxC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Feb 2021 21:53:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 249CA191906
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Feb 2021 02:57:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10129DA789
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Feb 2021 02:57:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 05249DA73F; Sat,  6 Feb 2021 02:57:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB69DDA73D;
        Sat,  6 Feb 2021 02:57:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Feb 2021 02:57:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 96AA542E0F80;
        Sat,  6 Feb 2021 02:57:03 +0100 (CET)
Date:   Sat, 6 Feb 2021 02:57:03 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC conntrack-tools PATCH] conntrack-tools: introduce
 conntrackdctl
Message-ID: <20210206015703.GA23084@salvia>
References: <161243463641.9380.7754148010781645692.stgit@endurance>
 <20210205122824.GA16269@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210205122824.GA16269@salvia>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 05, 2021 at 01:28:24PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Feb 04, 2021 at 11:32:06AM +0100, Arturo Borrero Gonzalez wrote:
> > Separate conntrackd command line client functionalities into a different
> > binary.
> > 
> > This should help with several things:
> >  * avoid reading and parsing the config file, which can fail in some enviroments, for example if
> >    conntrackd is running inside a netns and the referenced interfaces/addresses doesn't exist in
> >    the namespace conntrackd client command is running from.
> >  * easily update conntrakdctl with more functionalities without polluting the daemon binary
> >  * easier code maintenance
> [...]
> > @@ -333,15 +151,6 @@ int main(int argc, char *argv[])
> >  		exit(EXIT_FAILURE);
> >  	}
> >  
> > -	if (type == REQUEST) {
> > -		if (do_local_request(action, &conf.local, local_step) == -1) {
> > -			dlog(LOG_ERR, "can't connect: is conntrackd "
> > -			     "running? appropriate permissions?");
> > -			exit(EXIT_FAILURE);
> > -		}
> > -		exit(EXIT_SUCCESS);
> > -	}
> 
> The existing interface needs to be in place to be backward compatible.
> 
> I'm fine for you to add this, but we'll have to leave the existing
> interface for quite a bit of time, it might take years before we can
> deprecate the old way.

You could probably update conntrackd to invoke conntrackdctl when you
detect options that represent queries to the daemon. That would allow
you to retain backward compatibility. Hence, old scripts still work
while new ones might start using the new conntrackdctl command.

If the problem is that you would like to skip the config parsing
(which is what has triggered the errors when running things from the
netns environment IIRC), then, you could update the code to skip the
parsing:

- the user does not specify a configuration file

AND

- the options refer to a query to the daemon via UNIX socket.

That's another possibility to consider.
