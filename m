From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/2] netfilter: nfnetlink_acct: fix race between
 nfacct del and xt_nfacct destroy
Date: Thu, 18 Aug 2016 16:55:00 +0200
Message-ID: <20160818145500.GB2680@salvia>
References: <1471101182-15294-1-git-send-email-zlpnobody@163.com>
 <20160817222634.GA2798@salvia>
 <20160817223741.GA5476@salvia>
 <CAML_gOd71QecZabEgSz+YcGGsv66hJPZezudpt4YMp+WErUcnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:43245 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752314AbcHSCro (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Aug 2016 22:47:44 -0400
Content-Disposition: inline
In-Reply-To: <CAML_gOd71QecZabEgSz+YcGGsv66hJPZezudpt4YMp+WErUcnw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 18, 2016 at 06:41:12PM +0800, Liping Zhang wrote:
> So I think it seems better that we take another patch to fix the
> problem in cttimeout.

Fine with me, will take your patch, thanks!


