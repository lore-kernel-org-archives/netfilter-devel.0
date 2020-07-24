Return-Path: <SRS0=2b08=BD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9DFC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jul 2020 10:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B482120748
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jul 2020 10:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgGXKni (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Jul 2020 06:43:38 -0400
Received: from correo.us.es ([193.147.175.20]:48710 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgGXKnh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Jul 2020 06:43:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7001515C121
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jul 2020 12:43:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D8D3DA84D
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jul 2020 12:43:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5BB98DA7B6; Fri, 24 Jul 2020 12:43:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2952DA78D;
        Fri, 24 Jul 2020 12:43:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 Jul 2020 12:43:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B065D4265A32;
        Fri, 24 Jul 2020 12:43:33 +0200 (CEST)
Date:   Fri, 24 Jul 2020 12:43:33 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] nft: rearrange help output to group related options
 together
Message-ID: <20200724104333.GA22517@salvia>
References: <159550068914.41232.11789462187226358215.stgit@endurance>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159550068914.41232.11789462187226358215.stgit@endurance>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Arturo,

On Thu, Jul 23, 2020 at 12:38:09PM +0200, Arturo Borrero Gonzalez wrote:
[...]
> After this patch, the help output is:
> 
> === 8< ===
> % nft --help
> Usage: nft [ options ] [ cmds... ]
> 
> Options (general):
>   -h, help                      Show this help
>   -v, version                   Show version information
>   -V                            Show extended version information
> 
> Options (with operative meaning):
>   -c, check                     Check commands validity without actually applying the changes.
>   -f, file <filename>           Read input from <filename>
>   -i, interactive               Read input from interactive CLI
>   -I, includepath <directory>   Add <directory> to the paths searched for include files. Defaul[..]
> 
> Options (output text modifiers for data translation):
>
>   -N, reversedns                Translate IP addresses to names.
>   -S, service                   Translate ports to service names as described in /etc/services.
>   -u, guid                      Print UID/GID as defined in /etc/passwd and /etc/group.
>   -n, numeric                   Print fully numerical output.
>   -y, numeric-priority          Print chain priority numerically.
>   -p, numeric-protocol          Print layer 4 protocols numerically.
>   -T, numeric-time              Print time values numerically.
> 
> Options (output text modifiers for parsing and other operations):
>   -d, debug <level [,level...]> Specify debugging level (scanner, parser, eval, netlink, mnl, p[..]
>   -e, echo                      Echo what has been added, inserted or replaced.
>   -s, stateless                 Omit stateful information of ruleset.
>   -a, handle                    Output rule handle.
>   -j, json                      Format output in JSON
>   -t, terse                     Omit contents of sets.
> === 8< ===

My proposal:

% nft --help
Usage: nft [ options ] [ cmds... ]

Options (general):
  -h, help                      Show this help
  -v, version                   Show version information
  -V                            Show extended version information

Options (ruleset input handling):
  -f, file <filename>           Read input from <filename>
  -i, interactive               Read input from interactive CLI
  -I, includepath <directory>   Add <directory> to the paths searched for include files. Defaul[..]
  -c, check                     Check commands validity without actually applying the changes.

Options (ruleset list formatting):
  -a, handle                    Output rule handle.
  -s, stateless                 Omit stateful information of ruleset.
  -t, terse                     Omit contents of sets.
  -S, service                   Translate ports to service names as described in /etc/services.
  -N, reversedns                Translate IP addresses to names.
  -u, guid                      Print UID/GID as defined in /etc/passwd and /etc/group.
  -n, numeric                   Print fully numerical output.
  -y, numeric-priority          Print chain priority numerically.
  -p, numeric-protocol          Print layer 4 protocols numerically.
  -T, numeric-time              Print time values numerically.

Options (command output format):
  -e, echo                      Echo what has been added, inserted or replaced.
  -j, json                      Format output in JSON
  -d, debug <level [,level...]> Specify debugging level (scanner, parser, eval, netlink, mnl, p[..]
