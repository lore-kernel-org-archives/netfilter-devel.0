From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] tests: don't fail on modprobe since the
 driver might be built-in
Date: Thu, 24 Aug 2017 18:51:06 +0200
Message-ID: <20170824165106.GA15078@salvia>
References: <150280165807.21062.1101236218834054083.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:59054 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753422AbdHXQva (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 12:51:30 -0400
Content-Disposition: inline
In-Reply-To: <150280165807.21062.1101236218834054083.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 15, 2017 at 02:54:18PM +0200, Arturo Borrero Gonzalez wrote:
> From: Steve Langasek <steve.langasek@ubuntu.com>
> 
> Any of these nf drivers could be built-ins instead of modules; don't cause
> the testsuite to fail on modprobe, instead let it proceed and succeed/fail
> later based on actual test results.
> 
> Ideally we would check up front if the driver is loaded rather than trying
> to modprobe and ignoring failures, but there doesn't seem to be a reliable
> place to check this in the kernel filesystem.
> 
> Signed-off-by: Steve Langasek <steve.langasek@ubuntu.com>
> Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>

Applied, thanks Arturo.
