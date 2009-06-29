From: Patrick McHardy <kaber@trash.net>
Subject: Re:
Date: Mon, 29 Jun 2009 14:56:58 +0200
Message-ID: <4A48BA1A.2010309@trash.net>
References: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36414 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZF2M5E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:57:04 -0400
In-Reply-To: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
> 
> 
> here are a number of patches I am suggesting for the -master branch
> (-stable is separate in my view and my management, but see other
> discussion thread).
> Pullable from
> 	git://dev.medozas.de/iptables master
> 
> 
> Jan Engelhardt (9):
>       libiptc: split v4 and v6
>       extensions: collapse registration structures
>       iptables: allow for parse-less extensions
>       iptables: allow for help-less extensions
>       extensions: remove empty help and parse functions
>       xtables: add multi-registration functions
>       extensions: collapse data variables to use multi-reg calls
>       xtables: warn of missing version identifier in extensions
>       COMMIT_NOTES: notice to check for soversion bumps
> 
> Michael Granzow (1):
>       iptables: accept multiple IP address specifications for -s, -d

Looks good, pulled and pushed out again, thanks.

> (Shall I post the entire mergestat, or just the "X files changed" line?)

This is fine, I mainly want something comparable to the git pull output.
