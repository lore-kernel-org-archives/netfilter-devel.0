From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/2] tests: shell: add testcase for different defines
 usage
Date: Tue, 29 Nov 2016 22:20:11 +0100
Message-ID: <20161129212011.GB6428@salvia>
References: <148033796252.16068.18014556006915154561.stgit@nfdev2.cica.es>
 <148033796872.16068.6534024929186046379.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39666 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754882AbcK2VUQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 16:20:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 07F2E174D0D
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:20:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF4BBDA38F
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:20:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43205DA38E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:20:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <148033796872.16068.6534024929186046379.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 01:59:28PM +0100, Arturo Borrero Gonzalez wrote:
> From: Arturo Borrero Gonzalez <arturo@debian.org>
> 
> This testcase add some defines in a nft -f run and then uses
> them in different spots (which are not covered in previous testcases).
> 
>  * defines used to define another one
>  * different datatypes (numbers, strings, bits, ranges)
>  * usage in sets, maps, contatenatios
>  * single rules with single statements, multiple statements
>  * reuse define in same rule
> 
> Perhaps this isn't testing many different code path, but I find this
> interesting to have given it will probably be one of the most common
> use cases of nftables.

Also applied, thanks.
