From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 1/2] netfilter: nf_tables: rework atomic transaction updates
Date: Tue, 02 Apr 2013 12:03:39 +0300
Message-ID: <515A9EEB.2090701@linux.intel.com>
References: <1364502145-3701-1-git-send-email-pablo@netfilter.org> <1364502145-3701-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55396 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab3DBJEC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:04:02 -0400
In-Reply-To: <1364502145-3701-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> * A new begin operation to explicitly enter the transaction mode,
>    and remove the COMMIT flag per rule, as suggested by Tomasz.

Could you split your patch to 2?
- one which removes this flag and add *BEGIN* message stuff
- and a the later one which propose the rest


> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -37,6 +37,7 @@ enum nf_tables_msg_types {
>   	NFT_MSG_NEWSETELEM,
>   	NFT_MSG_GETSETELEM,
>   	NFT_MSG_DELSETELEM,
> +	NFT_MSG_BEGIN,
>   	NFT_MSG_COMMIT,
>   	NFT_MSG_ABORT,
>   	NFT_MSG_MAX,

Still, I think it's awkward to propose a fully-explicit message name for 
all but for the transaction ones.
NFT_MSG_BEGINTRANSACT or something like that, would be better.


Br,

Tomasz
