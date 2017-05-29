From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] iptables: Add file output option to iptables-save
Date: Mon, 29 May 2017 14:03:49 +0200
Message-ID: <20170529120349.GA11209@salvia>
References: <1495801516-14937-1-git-send-email-ojford@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver Ford <ojford@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41096 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751024AbdE2MDx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 08:03:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B88DD303D0A
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:03:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8508FF6F4
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:03:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA594FF2DC
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:03:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1495801516-14937-1-git-send-email-ojford@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 26, 2017 at 12:25:16PM +0000, Oliver Ford wrote:
> Adds an option to output the results of iptables-save,
> ip6tables-save, and xtables-save save to a file.
> Updates the man page with this new option.
> 
> Uses the dup2 call to replace stdout with the specified file.
> Error output is unchanged.
> 
> This is a feature requested by a Gentoo developer in
> Bugzilla #905.

Applied, thanks.

One minor glitch here.

> @@ -159,6 +162,21 @@ int ip6tables_save_main(int argc, char *argv[])
>  		case 'M':
>  			xtables_modprobe_program = optarg;
>  			break;
> +		case 'f':
> +			file = fopen(optarg, "w");
> +			if (file == NULL) {
> +				fprintf(stderr, "Failed to open file, error: %s\n",
> +					strerror(errno));
> +				exit(1);
> +			}
> +			int ret = dup2(fileno(file), STDOUT_FILENO);

We prefer not to have variable declarations in the body. So I slightly
mangled your patch. See patch in the git repo for final version.

Thanks.
