From: Patrick McHardy <kaber@trash.net>
Subject: Re: Port back 2.6 kernel patch to 2.4 which fixed bridge module panic
 	when received special fragments
Date: Wed, 13 Jan 2010 10:33:09 +0100
Message-ID: <4B4D9355.5000907@trash.net>
References: <3104bfb61001130130s4fbf1649oa9a12e7c855cc6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Dong Wei <dwei.zh@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38847 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab0AMJdM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:33:12 -0500
In-Reply-To: <3104bfb61001130130s4fbf1649oa9a12e7c855cc6e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dong Wei wrote:
> Hi, All
> 
> linux-2.6.32.3 fixed a kernel panic problem in bridge module when
> received special fragments.
> 
> see: http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-allstable.git;a=commit;h=8fa9ff6849bb86c59cc2ea9faadf3cb2d5223497
> 
> There is a ebtables kernel patch ebtables-brnf-11-2_vs_2.4.31.diff.gz
> which port back bridge netfilter.  After applied the kernel patch, the
> kernel panic problem will be introduced to the kernel. I made a kernel
> patch on 2.4.37.7 which can fix this problem. I think this patch
> should be merged to the ebtables-brnf-11-2_vs_2.4.31.diff.gz .

You need to send this to whomever is maintaining that patch,
probably Bart.
