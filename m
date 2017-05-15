From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v3] expression: print sets and maps in pretty format
Date: Mon, 15 May 2017 19:10:00 +0200
Message-ID: <20170515171000.GA5442@salvia>
References: <149371834124.14706.14801320069862319378.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:54849 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756274AbdEORKF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 13:10:05 -0400
Content-Disposition: inline
In-Reply-To: <149371834124.14706.14801320069862319378.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 02, 2017 at 11:47:02AM +0200, Arturo Borrero Gonzalez wrote:
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

Applied.

It would be really great if someone can just fetch the column length
from the terminal via ioctl(), then do poor man adjustment, eg.

Assuming ipv4 address maximum length is:

        strlen("255.255.255.255");

then, divide the column length by this, so we fit as many elements as
possible by this. And so on, for each datatype.
