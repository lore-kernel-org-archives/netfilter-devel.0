From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Tue, 06 Nov 2007 11:14:53 +0100
Message-ID: <47303E9D.2050909@trash.net>
References: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Ron Lai <ronlai@cs.stanford.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59266 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbXKFKO4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:14:56 -0500
In-Reply-To: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Ron Lai wrote:
> The log I got is listed below and the corresponding pcap file is attached.
> 
> Nov  1 21:14:54 ron kernel: ftp: Conntrackinfo = 2
> Nov  1 21:14:54 ron kernel: ftp: Conntrackinfo = 2
> Nov  1 21:14:54 ron kernel: ftp: dataoff(60) >= skblen(60)
> Nov  1 21:14:54 ron kernel: ftp: dataoff(60) >= skblen(60)
> Nov  1 21:14:54 ron kernel: ftp: dataoff(52) >= skblen(52)
> Nov  1 21:14:54 ron kernel: ftp: dataoff(52) >= skblen(52)


This very much looks like your packets hit the helper twice, which would
also explain the double sequence number adjustment. You didn't answer
my question before, are you using any patches?

