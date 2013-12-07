From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: netfilter: ipset: fix incorret comparison in hash_netnet4_data_equal()
Date: Sat, 07 Dec 2013 13:23:35 +0100
Message-ID: <19530135.WLZhKuFLxq@gentoovm>
References: <20131114154101.GA22625@redhat.com> <20131125214511.GA10043@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Dave Jones <davej@redhat.com>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:36791 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab3LGM31 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Dec 2013 07:29:27 -0500
In-Reply-To: <20131125214511.GA10043@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 25 November 2013 22:45:11 Pablo Neira Ayuso wrote:
> On Thu, Nov 14, 2013 at 10:41:01AM -0500, Dave Jones wrote:
> > Both sides of the comparison are the same, looks like a cut-and-paste
> > error.

Just a typo unfortunately.

The change should definitely make its way into mainline before 3.13 gets 
released - is it on track to be pulled into davem's net tree or should I get 
that sorted out myself?

Cheers,
Oliver.
