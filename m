From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: netfilter spurious ELOOP
Date: Thu, 26 Mar 2009 16:22:58 +0100
Message-ID: <200903261622.58453.thomas.jarosch@intra2net.com>
References: <200903242302.n2ON25u4024288@givry.fdupont.fr> <49CA7A19.8040805@trash.net> <49CA7AED.3050705@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:44182 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZCZPk6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:40:58 -0400
In-Reply-To: <49CA7AED.3050705@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Wednesday, 25. March 2009 19:41:49 Patrick McHardy wrote:
> Patrick McHardy wrote:
> > The same bug was also present in ip6_tables and arp_tables.
> > This is the patch I've committed:
>
> Thomas, I think this is likely to fix the ELOOP problem you reported
> in 2007 that we've never managed to track down:

Yes, you are right. It took me some hours to resurrect the original
setup from 2007 and trigger the problem. The patch fixed the issue :-)

Tested-by: Thomas Jarosch <thomas.jarosch@intra2net.com>

Thanks,
Thomas

