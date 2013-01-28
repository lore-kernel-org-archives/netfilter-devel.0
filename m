From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/8] build: also use libtool for install stage
Date: Mon, 28 Jan 2013 14:23:02 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301281417001.6071@nerf07.vanv.qr>
References: <1359056278-27618-1-git-send-email-jengelh@inai.de> <1359056278-27618-2-git-send-email-jengelh@inai.de> <20130128113351.GA15781@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:37077 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab3A1NXE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:23:04 -0500
In-Reply-To: <20130128113351.GA15781@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2013-01-28 12:33, Pablo Neira Ayuso wrote:
>> These RPATH entries are indeed undesired for libraries is in a system
>> location, which is why libtool produces another copy of the library on
>> installation. The makefile however missed using libtool during
>> installation (introduced with commit v1.4.17-1-g68e77a2).
>> This patch now resolves this.
>
>I hit this with this patch:
>
>make[1]: ...
>libtool: install: warning: relinking `libxt_AUDIT.la'

After looking into this, this output is normal and occurs everytime a 
.la links to another just-produced .la. This is because 
./extensions/libxt_AUDIT.so links to 
"/home/jengelh/code/iptables/libxtables/.libs/libxtables.so.9" 
(DT_NEEDED in readelf), but on install needs just "libxtables.so.9" when 
installed.
