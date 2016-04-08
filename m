From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/5] conntrack: add --proto to usage output.
Date: Fri, 8 Apr 2016 12:17:12 +0200
Message-ID: <20160408101712.GA2142@salvia>
References: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
 <1460053902-2200-2-git-send-email-mart.frauenlob@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35660 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbcDHKRS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 06:17:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2EEEEC1082
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:17:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1F4C5DA392
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:17:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F1208DA8F7
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:17:13 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1460053902-2200-2-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 07, 2016 at 08:31:38PM +0200, Mart Frauenlob wrote:
> 
> Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
> ---
>  src/conntrack.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/src/conntrack.c b/src/conntrack.c
> index dadbea5..162caa9 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -551,7 +551,7 @@ static const char usage_parameters[] =
>  	"  -d, --orig-dst ip\t\tDestination address from original direction\n"
>  	"  -r, --reply-src ip\t\tSource addres from reply direction\n"
>  	"  -q, --reply-dst ip\t\tDestination address from reply direction\n"
> -	"  -p, --protonum proto\t\tLayer 4 Protocol, eg. 'tcp'\n"
> +	"  -p, --proto, --protonum proto\t\tLayer 4 Protocol, eg. 'tcp'\n"

This works too:

# conntrack --pr tcp -L
tcp      6 431998 ESTABLISHED src=10.123.10.20 dst=1.2.3.4
sport=47488 dport=80 src=1.2.3.4 dst=10.123.10.20 sport=80
dport=47488 [ASSURED] mark=0 use=1

Really, I wouldn't worry about this.
