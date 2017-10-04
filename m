From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables: Add support for reserved header and addrs for routing
 header type 0
Date: Wed, 4 Oct 2017 13:10:25 +0200
Message-ID: <20171004111025.GB2575@salvia>
References: <1507100846.10633.17.camel@harryPotter>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:48840 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751816AbdJDLKd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 07:10:33 -0400
Content-Disposition: inline
In-Reply-To: <1507100846.10633.17.camel@harryPotter>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 04, 2017 at 12:37:26PM +0530, Harsha Sharma wrote:
> Hello,
> I'm working on task for adding support for reserved header and addrs for
> routing header type 0 in nftables. The code already uses macros like
> [RT0HDR_RESERVED], [RT0HDR_ADDR_1] in extensions/exthdr.c but they are
> not declared in parser_bison.c like other macros [RTHDR_TYPE] and
> [RTHDR_NEXTHDR].

They are indeed declared, please take the time to familiarize with
'git grep' to search for token on the git repository.

Thanks.
