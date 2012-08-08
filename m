From: Arif Hossain <etothepowerpi@gmail.com>
Subject: CRYPT target patch for newer kernel ?
Date: Wed, 08 Aug 2012 18:25:41 +0600
Message-ID: <1344428741.4763.21.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>,
	nefilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43309 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab2HHMgd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:36:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've come across many "CRYPT" or similar target patches will encrypt UDP
or TCP traffic.

Examples are :

1. A simple XOR target(-j XOR --key)

http://lists.netfilter.org/pipermail/netfilter-devel/2003-May/011532.html

2. A more robust ENCRYPT/DECRYPT target which will use full crypto api
of linux kernel:

http://0pointer.de/lennart/projects/seppl/

3. A generic CRYPT target

http://lwn.net/Articles/184670/

The last one i couldn't found any code. I've found the corresponding
mail in archive but the developer didn't submit it by a patch, but
submitted a download link which is a dead link anyway.

The first and second extensions are way out of date. 

I need these extensions. So i can develop one of my own, or port those
old ones. 

Before doing so, any newer extensions there which performs this? So that
i can modify that directly without porting it first?


-- 
Cheers

aft
aftnix@gmail.com

