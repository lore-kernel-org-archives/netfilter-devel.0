From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] expression: print sets and maps in pretty format
Date: Fri, 28 Apr 2017 16:15:29 +0200
Message-ID: <20170428141529.GA8946@salvia>
References: <149319751212.24658.15591983938007749887.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37986 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967139AbdD1OPn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 10:15:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C6191209925
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 16:15:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B89CFACBB
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 16:15:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02609ACBB
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 16:15:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149319751212.24658.15591983938007749887.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 26, 2017 at 11:05:55AM +0200, Arturo Borrero Gonzalez wrote:
> Print elements per line instead of all in a single line.
> The elements which can be 'short' are printed 5 per line,
> and others, like IPv4 addresses are printed 2 per line.
> 
> Example:
> 
> % nft list ruleset -nnn
> table ip t {
> 	set s {
> 		type inet_service
> 		elements = { 1, 2, 3, 4, 10,
> 			     432, 433, 434, 435, 436,
> 			     437, 438, 439, 440, 441,
> 			     442, 443, 444, 445, 446,
> 			     447, 448, 449, 450, 12345 }
> 	}
> 
> 	map m {
> 		type inet_service . iface_index : verdict
> 		elements = { 123 . "lo" : accept,
> 			     1234 . "lo" : accept,
> 			     12345 . "lo" : accept,
> 			     12346 . "lo" : accept,
> 			     12347 . "lo" : accept }
> 	}
> 
> 	set s3 {
> 		type ipv4_addr
> 		elements = { 1.1.1.1, 2.2.2.2,
> 			     3.3.3.3 }
> 	}
> }
> 
> NOTE: some testcases require updates because the output change.

I think this is a good starting point.

We can probably make a simple calculation based on the maximum length
of the string datatype, ie. strlen("255.255.255.255"), then use the
number of columns available and make a good guess on how much we can
fit in. It would still be something approximate.

Anyway, this can be refined later on.

Would you send me a v3 including the test updates? I ran them very
often here and I don't want to see them broken :).

Thanks!
