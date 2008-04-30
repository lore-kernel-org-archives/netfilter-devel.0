From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug finder
Date: Wed, 30 Apr 2008 14:10:09 +0200
Message-ID: <481861A1.2060209@trash.net>
References: <916407.60109.qm@web57406.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: bilal.amna@yahoo.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49583 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762989AbYD3MKN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:10:13 -0400
In-Reply-To: <916407.60109.qm@web57406.mail.re1.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

amna bilal wrote:
> Hi,
>
> The following are my netfilter patches for 2.6.17, which fix a couple of bad bugs:
>
> - The SCTP conntrack loop noticed by Ingo
> - The unchecked __copy_from/to in the compat code noticed by Linus
> - Two H.323 bugs found by the PROTOS c07-h2250v4 testsuite
>
> I'll push the SCTP patch to -stable as well. There is still at least one open bug in the H.323 helper, but I can't really keep up with the pace new bugs are discovered at currently.
>
> Any help will be appreciated.

Whats your question? The above just quotes one of my merge
requests without further context.


