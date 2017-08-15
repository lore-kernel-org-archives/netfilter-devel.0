From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 4/4] tests: Merge monitor and echo test suites
Date: Tue, 15 Aug 2017 12:35:45 +0200
Message-ID: <20170815103545.GB5889@salvia>
References: <20170814234305.2829-1-phil@nwl.cc>
 <20170814234305.2829-5-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:55705 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753423AbdHOKgE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2017 06:36:04 -0400
Content-Disposition: inline
In-Reply-To: <20170814234305.2829-5-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 15, 2017 at 01:43:05AM +0200, Phil Sutter wrote:
> The two test suites were pretty similar already, and since echo output
> is supposed to be identical to monitor output apart from delete
> commands, they can be merged together with litte effort.

Applied, thanks Phil.
