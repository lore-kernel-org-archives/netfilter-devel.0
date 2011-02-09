From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables: clean up main command loop
Date: Wed, 09 Feb 2011 08:13:43 +0100
Message-ID: <4D523EA7.40200@trash.net>
References: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45931 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab1BIHNo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Feb 2011 02:13:44 -0500
In-Reply-To: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 09.02.2011 02:48, schrieb Jan Engelhardt:
> This is a respin of the earlier patch. Now the cases for -j and -m
> are also in their own functions, and the shared code has
> moved to xshared.c.
> 
> 
> The following changes since commit e76ec99b48745b0e3c8aecbc91ed5bba186cf25f:
> 
>   libxt_cluster: fix inversion in the cluster match (2011-02-06 21:34:33 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (11):
>       src: collect do_command variables in a struct
>       src: move large default: block from do_command6 into its own function
>       src: share iptables_command_state across the two programs
>       src: deduplicate find_proto function
>       src: move OPT_FRAGMENT to the end so the list can be shared
>       src: put shared option flags into xshared
>       src: deduplicate and simplify implicit protocol extension loading
>       src: unclutter command_default function
>       src: move jump option handling from do_command6 into its own function
>       src: move match option handling from do_command6 into its own functions
>       iptables: fix error message for unknown options
> 

Pulled, thanks Jan!
