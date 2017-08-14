From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 2/2] xtables-compat: fix memory leak when listing
Date: Mon, 14 Aug 2017 11:40:21 +0200
Message-ID: <20170814094021.GB14445@salvia>
References: <20170808185346.3183-1-pablombg@gmail.com>
 <20170808185346.3183-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:45587 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752527AbdHNJkp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 05:40:45 -0400
Content-Disposition: inline
In-Reply-To: <20170808185346.3183-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 08, 2017 at 08:53:46PM +0200, Pablo M. Bermudo Garay wrote:
> The following memory leaks are detected by valgrind when
> ip[6]tables-compat is used for listing operations:

Also applied, thanks.
