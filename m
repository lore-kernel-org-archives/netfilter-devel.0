From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_bpf: fix missing __NR_bpf declaration
Date: Sun, 10 Sep 2017 22:06:33 +0200
Message-ID: <20170910200633.GA31073@salvia>
References: <20170910074453.17462-1-rafi@rbk.ms>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Rafael Buchbinder <rafi@rbk.ms>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53639 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbdIJUG7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Sep 2017 16:06:59 -0400
Content-Disposition: inline
In-Reply-To: <20170910074453.17462-1-rafi@rbk.ms>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 10, 2017 at 10:44:53AM +0300, Rafael Buchbinder wrote:
> This include is needed to compile the bpf_obj_get function properly,
> as it brings in the __NR_bpf declaration.

Applied, thanks.
