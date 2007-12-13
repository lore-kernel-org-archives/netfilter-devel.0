From: "Laurence J. Lane" <ljlane@debian.org>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file descriptor
Date: Thu, 13 Dec 2007 16:41:59 -0500
Message-ID: <cd6061db0712131341h166734ecjcdfd518cb8dfb5f8@mail.gmail.com>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
	 <47557D04.1040101@trash.net>
	 <beb91d720712040832p71981f85yd097f86614e680af@mail.gmail.com>
	 <47565BB3.9030500@trash.net>
	 <beb91d720712050339w7daeb392me3e3e3cc44bad0d@mail.gmail.com>
	 <4757C632.60503@trash.net>
	 <beb91d720712060325l22f4b609kdc481a64d36768e9@mail.gmail.com>
	 <beb91d720712090534i4df4513bk22b840d75e2ff543@mail.gmail.com>
	 <beb91d720712090611va682efcn80db6efb1efbaf0e@mail.gmail.com>
	 <475E6696.50805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.235]:20941 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbXLMVmB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:42:01 -0500
Received: by wr-out-0506.google.com with SMTP id c49so599724wra.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Dec 2007 13:42:01 -0800 (PST)
In-Reply-To: <475E6696.50805@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Dec 11, 2007 5:29 AM, Patrick McHardy <kaber@trash.net> wrote:

> It shouldn't, but I haven't seen any other complaints about this
> yet, so please try to either compile the kernel natively or also
> cross-compile iptables.

[ I'm jumping in on the end of the thread with comments not directed
at anyone specific.]

I just saw an additional comment to #446685. A search for "EABI iptables"
shows a known arm iptables' problem and at least one workaround is the chroot
method mentioned in the report.

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=446685
