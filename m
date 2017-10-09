From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] nftables: make pointers in string arrays constant
Date: Mon, 9 Oct 2017 15:28:46 +0200
Message-ID: <20171009132846.GA14213@salvia>
References: <20171006144754.17362-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:41020 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754727AbdJIN2v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2017 09:28:51 -0400
Content-Disposition: inline
In-Reply-To: <20171006144754.17362-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 06, 2017 at 08:17:54PM +0530, Harsha Sharma wrote:
> Static const char * array should be static const char *
> const array as per linux-kernel coding style

Applied.
