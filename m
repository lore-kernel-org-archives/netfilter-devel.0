From: Afschin Hormozdiary <Afschin.Hormozdiary@Sophos.com>
Subject: Re: [PATCH next] libnetfilter_conntrack: don't ignore ATTR_CONNLABELS
Date: Fri, 17 May 2013 09:33:05 +0200
Message-ID: <5195DD31.8060103@Sophos.com>
References: <a17383ac-860c-4a6f-baf1-a382ce895a5c@DE-WIE-EXCH3A.green.sophos> <20130516104700.GA3984@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.sophos.com ([145.253.124.138]:38181 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab3EQHgL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 May 2013 03:36:11 -0400
In-Reply-To: <20130516104700.GA3984@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/16/2013 12:47 PM, Pablo Neira Ayuso wrote:
 > On Thu, May 16, 2013 at 11:30:43AM +0200, Afschin Hormozdiary wrote:
 >> The libnfnetlink based backend 'build.c' currently ignores
 >> ATTR_CONNLABELS and ATTR_CONNLABELS_MASK.
 >>
 >> The libmnl based backend 'build_mnl.c' instead handles
 >> both attributes correct.
 >>
 >> Add function to set CTA_LABELS and CTA_LABELS_MASK
 >> if required.
 >
 > I'm fine with this change, but you also need to modify the parsing
 > function not to leave connlabel support for the libnfnetlink-based API
 > incomplete.

Good point, i will resend a patch that also includes the parsing function.
