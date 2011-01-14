From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCHv2] netfilter: audit target to record accepted/dropped
 packets
Date: Fri, 14 Jan 2011 18:51:57 +0000
Message-ID: <4D309B4D.2010701@googlemail.com>
References: <20110114152024.GA9654@canuck.infradead.org> <4D306FBB.8020705@trash.net> <20110114161937.GA22101@canuck.infradead.org> <20110114165937.GA5759@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	linux-audit@redhat.com, Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58749 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab1ANSwH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:52:07 -0500
Received: by wyb28 with SMTP id 28so3124791wyb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jan 2011 10:52:05 -0800 (PST)
In-Reply-To: <20110114165937.GA5759@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Thomas Graf wrote:
> This patch adds a new netfilter target which creates audit records
> for packets traversing a certain chain.
>   
Just a question/suggestion from a (regular) user point of view: Would it 
be possible to store the entire packet content or would that prove a bit 
too much? If that's possible I am dumping tcpdump (pun intended ;-) ) 
for good!

