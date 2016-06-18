From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools] configure: Fix flex version check
Date: Sat, 18 Jun 2016 14:42:45 +0200
Message-ID: <20160618124245.GA13901@salvia>
References: <1466191063-25552-1-git-send-email-shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52245 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbcFRMmy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jun 2016 08:42:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BA250E8E8B
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Jun 2016 14:42:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AAA65ADF4
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Jun 2016 14:42:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9BE40CA0FF
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Jun 2016 14:42:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466191063-25552-1-git-send-email-shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Shivani,

Thanks for following up on this, see comment below.

On Sat, Jun 18, 2016 at 12:47:43AM +0530, Shivani Bhardwaj wrote:
> Following the fixes for version check in iptables and nftables, make
> conntrack-tools avoid generating false warning for Flex version greater
> than 2.5.x.
> 
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  configure.ac | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index c541034..3bc5155 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -46,7 +46,7 @@ flex_major=`echo $flex_version| cut -d . -f 1`
>  flex_minor=`echo $flex_version| cut -d . -f 2`
>  flex_rev=`echo $flex_version| cut -d . -f 3`
>   
> -if test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33"; then
> +if (test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33") || (test "$flex_major" -eq "2" && test "$flex_minor" -gt "5") || test "$flex_major" -gt "2"; then
>  	AC_MSG_RESULT([$flex_version. OK])
>  else
>  	AC_MSG_WARN([flex version $flex_version found.

I'm starting to think that it's better to get rid of this version
check. This was introduced in 2008:

        ed50c34 ("add flex version warning (better with >= 2.5.33)")

I can see RPM packages for 2.5.53 since 2008.

The development of conntrack-tools a bit before that time, so I think
it's better to nuke these checks, better since we have less code to
maintain :)

Thanks.
