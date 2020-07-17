Return-Path: <SRS0=dQkn=A4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C08C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 09:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E30B62076A
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 09:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgGQJ1v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 05:27:51 -0400
Received: from correo.us.es ([193.147.175.20]:44032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbgGQJ1v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 05:27:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4A9F71798BE
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2020 11:27:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BED0DA860
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2020 11:27:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2B2B8DA850; Fri, 17 Jul 2020 11:27:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF402DA78A;
        Fri, 17 Jul 2020 11:27:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 17 Jul 2020 11:27:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BC2D04265A32;
        Fri, 17 Jul 2020 11:27:44 +0200 (CEST)
Date:   Fri, 17 Jul 2020 11:27:44 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Giuseppe Scrivano <gscrivan@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH v3] iptables: accept lock file name at runtime
Message-ID: <20200717092744.GA17027@salvia>
References: <20200717083940.618618-1-gscrivan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717083940.618618-1-gscrivan@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 17, 2020 at 10:39:40AM +0200, Giuseppe Scrivano wrote:
> allow users to override at runtime the lock file to use through the
> XTABLES_LOCKFILE environment variable.
> 
> It allows to use iptables when the user has granted enough
> capabilities (e.g. a user+network namespace) to configure the network
> but that lacks access to the XT_LOCK_NAME (by default placed under
> /run).
> 
> $ XTABLES_LOCKFILE=/tmp/xtables unshare -rn iptables ...
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> ---
>  configure.ac           |  1 +
>  iptables/iptables.8.in |  8 ++++++++
>  iptables/xshared.c     | 11 ++++++++---
>  3 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 31a8bb26..d37752a2 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -219,6 +219,7 @@ AC_SUBST([libxtables_vmajor])
>  
>  AC_DEFINE_UNQUOTED([XT_LOCK_NAME], "${xt_lock_name}",
>  	[Location of the iptables lock file])
> +AC_SUBST([XT_LOCK_NAME], "${xt_lock_name}")
>  
>  AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
>  	iptables/Makefile iptables/xtables.pc
> diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
> index 054564b3..999cf339 100644
> --- a/iptables/iptables.8.in
> +++ b/iptables/iptables.8.in
> @@ -397,6 +397,14 @@ corresponding to that rule's position in the chain.
>  \fB\-\-modprobe=\fP\fIcommand\fP
>  When adding or inserting rules into a chain, use \fIcommand\fP
>  to load any necessary modules (targets, match extensions, etc).
> +
> +.SH LOCK FILE
> +iptables uses the \fI@XT_LOCK_NAME@\fP file to take an exclusive lock at
> +launch.
> +
> +The \fBXTABLES_LOCKFILE\fP environment variable can be used to override
> +the default setting.
> +
>  .SH MATCH AND TARGET EXTENSIONS
>  .PP
>  iptables can use extended packet matching and target modules.
> diff --git a/iptables/xshared.c b/iptables/xshared.c
> index c1d1371a..7d97637f 100644
> --- a/iptables/xshared.c
> +++ b/iptables/xshared.c
> @@ -249,15 +249,20 @@ void xs_init_match(struct xtables_match *match)
>  static int xtables_lock(int wait, struct timeval *wait_interval)
>  {
>  	struct timeval time_left, wait_time;
> +	const char *lock_file;
>  	int fd, i = 0;
>  
>  	time_left.tv_sec = wait;
>  	time_left.tv_usec = 0;
>  
> -	fd = open(XT_LOCK_NAME, O_CREAT, 0600);
> +	lock_file = getenv("XTABLES_LOCKFILE");
> +	if (lock_file == NULL || lock_file[0] == '\0')

Probably remove the check for lock_file[0] == '\0'

Or is this intentional?

git grep getenv in iptables does not show any similar handling for
getenv().

Thanks.
