From: Steven Jan Springl <steven@springl.ukfsn.org>
Subject: Re: nf_conntrack_proto_udplite
Date: Thu, 23 Apr 2009 15:25:54 +0100
Message-ID: <200904231525.54924.steven@springl.ukfsn.org>
References: <200904222106.29497.steven@springl.ukfsn.org> <49F04334.9000905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.springl.ukfsn.org ([84.45.199.6]:42490 "EHLO
	mail.springl.ukfsn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZDWOZ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:25:57 -0400
In-Reply-To: <49F04334.9000905@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 23 April 2009 11:30:12 Patrick McHardy wrote:
> Steven Jan Springl wrote:
> > Hello
> >
> > Whilst testing kernel 2.6.30-rc3 I have noticed that when I issue
> > command:
> >
> > modprobe nf_conntrack_proto_udplite
> >
> > the following message is produced:
> >
> > FATAL: Error inserting nf_conntrack_proto_udplite
> > (/lib/modules/2.6.30-rc3/kernel/net/netfilter/nf_conntrack_proto_udplite.
> >ko): Invalid argument
> >
> > Is this a kernel bug or have I done something wrong?
>
> Thanks for the report, it seems the IPv6 udplite protocol was
> forgotten during a recent API change.
>
> Does this patch help?

Patrick

The patch has fixed the problem. Thank you.

Steven.
