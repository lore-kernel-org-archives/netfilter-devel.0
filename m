From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] parser_bison: no need for 'name' token for meters
Date: Fri, 24 Nov 2017 15:56:39 +0100
Message-ID: <20171124145639.GA9026@salvia>
References: <20171124132900.28301-1-pablo@netfilter.org>
 <20171124132900.28301-2-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45036 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753572AbdKXO4o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Nov 2017 09:56:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A8C36392E03
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 15:56:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A8DFDA804
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 15:56:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 840B1DA843
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 15:56:40 +0100 (CET)
Received: from us.es (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5D75C405032F
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 15:56:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171124132900.28301-2-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 24, 2017 at 02:29:00PM +0100, Pablo Neira Ayuso wrote:
> @@ -2518,6 +2515,23 @@ meter_stmt_opt		:	TABLE			identifier
>  			}
>  			;
>  
> +meter_stmt_alloc	:	METER	identifier		'{' meter_key_expr stmt '}'
> +			{
> +				$$ = meter_stmt_alloc(&@$);
> +				$$->meter.name = $2;
> +				$$->meter.key  = $4;
> +				$$->meter.stmt = $5;
> +				$$->location  = @$;
> +			}

I'm removing from here...

> +			|	METER	'{' meter_key_expr stmt '}'
> +			{
> +				$$ = meter_stmt_alloc(&@$);
> +				$$->meter.key  = $3;
> +				$$->meter.stmt = $4;
> +				$$->location  = @$;
> +			}

to there.

There's no point in nameless meters as we discussed, sorry, this just
slipped through.

Will be mangling this before pushing it out.
