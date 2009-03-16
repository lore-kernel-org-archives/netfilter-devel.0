From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack_sip bug
Date: Mon, 16 Mar 2009 16:51:33 +0100
Message-ID: <49BE7585.8090002@trash.net>
References: <49B122A0.7080905@telegroup.com.ua> <49B76CD7.5030806@telegroup.com.ua> <49BE6CD0.1020803@trash.net> <49BE7375.8070503@telegroup.com.ua>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Andrew O. Zhukov" <andre@telegroup.com.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49039 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZCPPvg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:51:36 -0400
In-Reply-To: <49BE7375.8070503@telegroup.com.ua>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andrew O. Zhukov wrote:
> I even find it in sources several minutes before send this post.
> 
> Look at nf_conntrack_sip.c
> after comments
> /* RTP info only in some SDP pkts */

Ah I see :) That version is completely out of date and known to be broken.
2.6.26 includes a rewritten version that should work fine, please try
that or the 2.6.25 backport available at:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.25-sip.git
