Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F42C433E6
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8E3464E46
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhBARGn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:06:43 -0500
Received: from correo.us.es ([193.147.175.20]:55616 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhBARGk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:06:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B4E46DFC1
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2021 18:05:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E541DA78F
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2021 18:05:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 13FF3DA78D; Mon,  1 Feb 2021 18:05:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 165DCDA78F;
        Mon,  1 Feb 2021 18:05:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Feb 2021 18:05:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id ED41942DC6DD;
        Mon,  1 Feb 2021 18:05:51 +0100 (CET)
Date:   Mon, 1 Feb 2021 18:05:51 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH 1/3] tests: introduce new python-based
 framework for running tests
Message-ID: <20210201170551.GA28275@salvia>
References: <161144773322.52227.18304556638755743629.stgit@endurance>
 <20210201033147.GA20941@salvia>
 <949b08b1-d7c7-c040-7218-9df63562c032@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <949b08b1-d7c7-c040-7218-9df63562c032@netfilter.org>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 01, 2021 at 11:49:02AM +0100, Arturo Borrero Gonzalez wrote:
> On 2/1/21 4:31 AM, Pablo Neira Ayuso wrote:
[...]
> > * Missing yaml dependency in python in my test machine
> > 
> > Traceback (most recent call last):
> >    File "cttools-testing-framework.py", line 36, in <module>
> >      import yaml
> > ModuleNotFoundError: No module named 'yaml'
> > 
> > this is installed from pip, right? Just a note in the commit message
> > is fine.
> 
> It was already present in the commit message.
> 
> I made it more clear:
> 
> === 8< ===
> On Debian machines, it requires the *python3-yaml* package to be installed
> as a dependency
> === 8< ===

Sorry, I overlook this.

> > * Would it be possible to define the scenario in shell script files?
> >    For example, to define the "simple_stats" scenario, the YAML file
> >    looks like this:
> > 
> > - name: simple_stats
> > - script: shell/simple_stats.sh
> > 
> > The shell script takes "start" or "stop" as $1 to set up the scenario.
> > For developing more test, having the separated shell script might be
> > convenient.
> > 
> 
> This is already supported:
> 
> === 8< ===
> - name: myscenario
>   start:
>     - ./script.sh start
>   stop:
>     - ./script.sh stop
> === 8< ===

Ok, I've sent a patch to move the netns network setup to a shell
script:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210201170015.28217-1-pablo@netfilter.org/

> > Thanks !
> > 
> 
> Thanks for the review. I made the changes you requested and pushed it to the
> repository.
> 
> I plan to follow up soon with more tests.
>
> Question: I have a few testcases that trigger bugs, segfaults etc. Would it
> be OK to create something like 'failingtestcases.yaml' and register all
> those bugs there until the get fixed? That way we have reproducible bugs
> until we can fix them.

That's fine, but before we add more tests, please let's where to move
more inlined configurations in the yaml files to independent files
that can be reused by new tests.

Thanks.
