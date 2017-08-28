From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_conntrack: remove unused code in
 nf_conntrack_proto_generic.c
Date: Mon, 28 Aug 2017 17:52:12 +0200
Message-ID: <20170828155212.GA22963@salvia>
References: <2506ca6f6d8fdc51d85fc77e558b1662ff18eba9.1503913723.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37802 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751349AbdH1Pwg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 11:52:36 -0400
Content-Disposition: inline
In-Reply-To: <2506ca6f6d8fdc51d85fc77e558b1662ff18eba9.1503913723.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 28, 2017 at 11:52:07AM +0200, Davide Caratti wrote:
> L4 protocol helpers for DCCP, SCTP and UDPlite can't be built as kernel
> modules anymore, so we can remove code enclosed in
>  #ifdef CONFIG_NF_CT_PROTO_{DCCP,SCTP,UDPLITE}_MODULE

Applied, thanks.
