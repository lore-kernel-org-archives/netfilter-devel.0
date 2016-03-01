From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: extensions: iptables-translate prints extra
 "nft" after printing any error
Date: Tue, 1 Mar 2016 18:59:02 +0100
Message-ID: <20160301175902.GA32303@salvia>
References: <CAHSpA592Skw5FonNYgO_o19c9PQqUe_Foagr6_Nm2USG8rVnBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guruswamy Basavaiah <guru2018@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51449 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbcCAR7N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 12:59:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 47CFA4BA1A
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 18:59:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3069EDA38E
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 18:59:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 995EEDA3AE
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 18:59:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAHSpA592Skw5FonNYgO_o19c9PQqUe_Foagr6_Nm2USG8rVnBg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 26, 2016 at 12:34:50AM +0530, Guruswamy Basavaiah wrote:
>  Output of command "./iptables-translate junk" is Bad argument
>  `junk' Try `iptables-translate -h' or 'iptables-translate --help' for more
>  information. nft
> 
> Output of command "./iptables-translate -B" is
> iptables-translate v1.6.0: unknown option "-B"
> Try `iptables-translate -h' or 'iptables-translate --help' for more
> information.
> nft
> 
> nft should have not been printed in both the cases. Moving the printf
> call after the do_parse function call

Manually applied, thanks.

Please note that your patches are being mangled by your MUA. This is
problematic since patchwork will not catch your patches:

http://patchwork.ozlabs.org/project/netfilter-devel/list/

Please, fix this, you'll save me time if you send me proper patches.
Thanks.
