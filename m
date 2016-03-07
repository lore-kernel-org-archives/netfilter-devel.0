From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] doc: nft: Fixed a typo and added/changed punctuation
Date: Mon, 7 Mar 2016 19:06:00 +0100
Message-ID: <20160307180600.GA6777@salvia>
References: <20160307145420.GA4852@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Piyush Pangtey <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54926 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbcCGSGF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 13:06:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EAC777400
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:06:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DCD76DA8F9
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:06:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D8F54DA3A8
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:06:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160307145420.GA4852@fate>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2016 at 08:24:20PM +0530, Piyush Pangtey wrote:
> Instead of using '/' longopts , use ',' ,as followed by man pages of other
> programs.
> 
> Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
> ---
>  doc/nft.xml | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/doc/nft.xml b/doc/nft.xml
> index 7cc9988..eab97f5 100644
> --- a/doc/nft.xml
> +++ b/doc/nft.xml
> @@ -156,8 +156,8 @@ vi:ts=4 sw=4
>  		<refsect2>
>  			<title>Lexical conventions</title>
>  			<para>
> -				Input is parsed line-wise. When the last character of a line just before
> -				the newline character is a non-quoted backslash (<literal>\</literal>),
> +				Input is parsed line-wise. When the last character of a line, just before
> +				the newline character, is a non-quoted backslash (<literal>\</literal>),
>  				the next line is treated as a continuation. Multiple commands on the
>  				same line can be separated using a semicolon (<literal>;</literal>).
>  			</para>

This looks good, but this chunk doesn't match the description, right?
