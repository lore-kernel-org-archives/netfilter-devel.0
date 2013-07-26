From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: iptables-xml: Fix various parsing bugs
Date: Fri, 26 Jul 2013 16:52:21 +0200
Message-ID: <20130726145221.GA28740@localhost>
References: <20130620125336.GA15704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46442 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759187Ab3GZOw1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:52:27 -0400
Content-Disposition: inline
In-Reply-To: <20130620125336.GA15704@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 20, 2013 at 08:53:36AM -0400, Phil Oester wrote:
> There are two bugs in iptables-xml do_rule_part parsing corrected by this patch:
> 
> 1) Ignore "-A <chain>" instead of just "-A"
> 2) When checking to see if we need a <match> tag, inversion needs to be taken
>    into account
> 
> This closes netfilter bugzilla #679.

Applied with comestic change, thanks Phil.

> Phil
> 
> Signed-off-by: Phil Oester <kernel@linuxace.com>
> 
> 

> diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
> index 4b12bd4..99d7527 100644
> --- a/iptables/iptables-xml.c
> +++ b/iptables/iptables-xml.c
> @@ -367,7 +367,8 @@ static void
>  do_rule_part(char *leveltag1, char *leveltag2, int part, int argc,
>  	     char *argv[], int argvattr[])
>  {
> -	int arg = 1;		// ignore leading -A
> +	int i;
> +	int arg = 2;		// ignore leading -A <chain>
>  	char invert_next = 0;
>  	char *spacer = "";	// space when needed to assemble arguments
>  	char *level1 = NULL;
> @@ -401,9 +402,14 @@ do_rule_part(char *leveltag1, char *leveltag2, int part, int argc,
>  
>  	/* Before we start, if the first arg is -[^-] and not -m or -j or -g 
>  	   then start a dummy <match> tag for old style built-in matches.  
> -	   We would do this in any case, but no need if it would be empty */

We prefer this comment style (similar to kernel coding style):

/* This is a long comment ...
 * ...
 */

/* This is a short comment */

*Not your fault*, of course, that was already there, including some
trailing whitespace.

In general, I don't like patches to address comestic stuff only, I
think they generate too much noise, so I prefer that comestic stuff
gets fixed while fixing/enhancing some real thing, like in this case.
