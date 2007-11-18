From: Al Boldi <a1426z@gawab.com>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Sun, 18 Nov 2007 09:05:45 +0300
Message-ID: <200711180905.45839.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [212.12.190.27] ([212.12.190.27]:44599 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751377AbXKRGFv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Nov 2007 01:05:51 -0500
Received: from localhost ([10.0.0.111])
	by raad.intranet (8.8.7/8.8.7) with ESMTP id JAA15183
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Nov 2007 09:05:42 +0300
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Well, the point of the avanced option is to handle *advanced*
> cases, so we don't need to cover manual adjustments (including
> things like shorewall which are usually installed manually). The
> default cases for people not having touched their *firewall*
> configuration is enough. I wasn't able to find the SuSE-script,
> but from a screenshot I could see that they do optionally handle
> IPsec. So what I'm saying is that we should include f.i. the policy
> match, and all other modules needed without manually attending
> to the firewall, but nothing more.
>
> IOW, its for people like Linus, presumably not touching their
> default configuration, but unwilling to go through the 50+
> options to decide themselves.
>
> For people who want to compile-test them all (like me), we
> still can have a CONFIG_NETFILTER_ALL option hidden under
> CONFIG_NETFILTER_ADVANCED for simplicity, but that is a
> different topic.

CONFIG_NETFILTER_ALL sounds great.  So why not have CONFIG_NETFILTER_MIN for 
a minimal setup, which would only select:

  targets: NOTRACK, MASQ, REJECT, LOG
  matches: state, mport

Then let the user select any additional modules, like IPsec/policy or 
FTP/helpers.


Thanks!

--
Al

