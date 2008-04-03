From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/24] [NETFILTER]: rename NF_ARP to AF_ARP and assign
 a non-clashing value
Date: Thu, 03 Apr 2008 13:59:02 +0200
Message-ID: <47F4C686.2000700@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <846a3697441043b20a99abac8046aad205938256.1207134547.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64830 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbYDCL7H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 07:59:07 -0400
In-Reply-To: <846a3697441043b20a99abac8046aad205938256.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> For coming Xtables patches, we want to use AF_UNSPEC, but NF_ARP
> currently evaluates to the same value so it gets changed.
> 
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -179,6 +179,7 @@ struct ucred {
>  #define AF_ASH		18	/* Ash				*/
>  #define AF_ECONET	19	/* Acorn Econet			*/
>  #define AF_ATMSVC	20	/* ATM SVCs			*/
> +#define AF_ARP		21	/* Address Resolution for IPv4	*/

Did you make sure this value wasn't ever used by something else?
Is this used by userspace? If not, why change it?
