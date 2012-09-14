From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] netfilter: Allow xt_nat.c and x_tables.c to compiled in
Date: Fri, 14 Sep 2012 03:33:50 +0000 (UTC)
Message-ID: <k2u8iu$75g$1@ger.gmane.org>
References: <87627hfi69.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53613 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778Ab2INDeF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:34:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1TCMfO-0007ja-HE
	for netfilter-devel@vger.kernel.org; Fri, 14 Sep 2012 05:34:06 +0200
Received: from 112.132.139.218 ([112.132.139.218])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Sep 2012 05:34:06 +0200
Received: from xiyou.wangcong by 112.132.139.218 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Sep 2012 05:34:06 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 14 Sep 2012 at 02:32 GMT, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> xt_init in x_tables.c must be called before xt_nat_init in xt_nat.c
> Reorder the makefile so that x_tables.o comes before xt_nat.o in
> netfilter.o.
>
> This allows me to built a kernel with both of these modules compiled in.
>

There is a patch to fix the same issue:
http://1984.lsi.us.es/git/nf-next/commit/?id=00545bec9412d130c77f72a08d6c8b6ad21d4a1

