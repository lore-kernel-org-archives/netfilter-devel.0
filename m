From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Mostly documentation fixes
Date: Sun, 30 Sep 2012 23:16:59 +0200
Message-ID: <20120930211659.GB13681@1984>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56051 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab2I3VRD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 17:17:03 -0400
Content-Disposition: inline
In-Reply-To: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 30, 2012 at 12:22:03PM +0200, Jan Engelhardt wrote:
> 
> Hi,
> 
> 
> It was that time of the year again to process reports from the
> Debian bug tracking system. :)
> 
> ===
> The following changes since commit 0d701631625898ac33fb53c67ed2b529668fe0d7:
> 
>   libxt_state: replace as an alias to xt_conntrack (2012-09-30 11:21:25 +0200)
> 
> are available in the git repository at:
> 
>   git://git.inai.de/iptables master
> 
> for you to fetch changes up to 6cf011116fc4752cde75eabe3b1b3f2a93ae27bd:
> 
>   src: remove faulty deprecated marker in libipt_LOG source (2012-09-30 12:17:31 +0200)

All patches but:

iptables: fix order of internal commands list

look fine to me. For iptables-restore: kill unused -b option I'd be
more conservative, ie. spotting a warning to say that the option is
meaningless (so we make sure we don't break stupid scripts).

Apart from that, all OK. Please feel free to add:

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks for your updates Jan.

> ----------------------------------------------------------------
> Jan Engelhardt (17):
>       doc: clean up interpunction in state list for xt_conntrack
>       doc: deduplicate extension descriptions into a new manpage
>       doc: trim "state" manpage and reference conntrack instead
>       doc: have NOTRACK manpage point to CT instead
>       doc: mention iptables-apply in the SEE ALSO sections
>       iptables: fix order of internal commands list
>       iptables: implement --line-numbers for iptables -S
>       iptables-restore: kill unused -b option
>       doc: rename .8.in files to .8in
>       doc: add package version to all manpages
>       doc: fixup omissions in ip6tables-restore.8
>       doc: document iptables-restore's -t option
>       doc: document iptables-restore's -v option
>       doc: document iptables-restore's -M option
>       doc: document iptables-restore's -h option
>       doc: name the supported log levels for ipt_LOG
>       src: remove faulty deprecated marker in libipt_LOG source
