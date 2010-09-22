From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: xtables does not reconise ipportiphash/ipportnethash sets
Date: Wed, 22 Sep 2010 20:19:47 +0100
Message-ID: <4C9A56D3.109@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45450 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab0IVT0R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:26:17 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so186638wyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Sep 2010 12:26:16 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I compiled xtables (1.28) from source on x86_64 system and it installs 
OK, except that none of the above two set types seem to be recognised!

When I type ipport --help ipportnethash/ipportiphash it all works as 
expected (the same goes for the man pages), but when I actually try to 
create this type of set I am getting 'unknown set type' error message.

Close examination of /lib/modules/... directory reveals that, actually, 
NO ip_set_ipportiphash.ko/ipportnethash.ko modules are present. The 
source directory (extensions/ipset) contains the source and header 
files, but that's about it - no .o, .so or .ko files, which leads me to 
believe that they have been completely ignored by the Makefile.

There is an additional file in that directory called modules.order, 
which seems to be automatically generated, and it does NOT contain these 
two files in its list.
