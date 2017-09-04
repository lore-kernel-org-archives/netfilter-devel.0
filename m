From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 2/2] src: get rid of printf
Date: Mon, 4 Sep 2017 22:43:48 +0200
Message-ID: <20170904204348.GB14434@salvia>
References: <20170903223441.GB12383@salvia>
 <20170904075558.10129-1-eric@regit.org>
 <20170904075558.10129-3-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:50004 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753962AbdIDUoQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2017 16:44:16 -0400
Content-Disposition: inline
In-Reply-To: <20170904075558.10129-3-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 04, 2017 at 09:55:58AM +0200, Eric Leblond wrote:
> This patch introduces the nft_print function that has to be used
> instead of printf to output information that were previously send
> to stdout. This function accumulate the output in a buffer that can
> be fetched by the user with the nft_ctx_get_output() function.
> 
> This modification will allow the libnftables library to provide an
> easy way to the users to get the output data and display them like
> they want.

tests/shell/./run-tests

is reporting problems with this :-(
