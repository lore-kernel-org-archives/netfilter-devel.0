From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: RFC: Probably wrong code in nf_nat_snmp_basic.c
Date: Mon, 28 Nov 2011 16:46:01 +0100
Message-ID: <201111281646.01087.thomas.jarosch@intra2net.com>
References: <4EC5791A.1040005@intra2net.com> <20111118003429.GA30271@1984> <201111180943.29443.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, James Morris <jmorris@namei.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:48763 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab1K1PqD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:46:03 -0500
In-Reply-To: <201111180943.29443.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Friday, 18. November 2011 09:43:29 Thomas Jarosch wrote:
> > Indeed. I'll be happy to take a patch for this. If you don't make it
> > in the following days, no problem, I'll take of this myself. Thanks
> > for the report.
> 
> The if() statement is probably in there for a reason. I'm not familiar
> with the internal details of the ct stuff, perhaps map.from/map.to
> should be swapped or something like that.
> 
> James, any idea what's going on?

Hmm, James is probably busy.

Would be nice if you could take over this, Pablo.

Thanks,
Thomas
