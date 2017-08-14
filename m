From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 1/2] xtables-compat-restore: fix several memory
 leaks
Date: Mon, 14 Aug 2017 11:40:11 +0200
Message-ID: <20170814094011.GA14445@salvia>
References: <20170808185346.3183-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:45579 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbdHNJkf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 05:40:35 -0400
Content-Disposition: inline
In-Reply-To: <20170808185346.3183-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 08, 2017 at 08:53:45PM +0200, Pablo M. Bermudo Garay wrote:
> The following memory leaks are detected by valgrind when
> ip[6]tables-compat-restore is executed:
> 
> valgrind --leak-check=full iptables-compat-restore test-ruleset

Applied, thanks.
