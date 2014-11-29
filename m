From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ipset website
Date: Sat, 29 Nov 2014 12:33:21 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1411291212290.5728@nerf08.vanv.qr>
References: <547919CB.7030202@nospam.hostisimo.com> <alpine.LSU.2.11.1411290212430.31411@nerf08.vanv.qr> <547946BA.106@nospam.hostisimo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mike Wright <nobody@nospam.hostisimo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:49608 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbaK2LdX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Nov 2014 06:33:23 -0500
In-Reply-To: <547946BA.106@nospam.hostisimo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2014-11-29 05:08, Mike Wright wrote:
>> Forcing a scrollbar also seems backwards. If the table is to
>> have a consistent size irrespective of scrollbar, one would
>> probably use CSS's position: or float:.
>>
> Those solutions won't work.  The scroll bar is added to the page by the
> browser, outside of the body, which causes the body width to narrow

Hm, too bad.

"overflow-y: scroll" though is better-suited than "height: 100.1%",
and according to http://stackoverflow.com/a/7607206 , should be on
the html object, not body.
