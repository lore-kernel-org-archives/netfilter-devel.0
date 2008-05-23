From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [0/3] conntrack event kernel issues
Date: Fri, 23 May 2008 14:13:48 +0100
Message-ID: <4836C30C.8020305@gmx.ch>
References: <1211447573.6878.36.camel@pumper.lan.luxnet.ch> <48369678.7000905@trash.net> <4836AB4C.8030304@gmx.ch> <4836ACA9.5040507@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57732 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755520AbYEWNNu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2008 09:13:50 -0400
In-Reply-To: <4836ACA9.5040507@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
>> Then there is this thing with the TCP RST. I think, that the event 
>> data should be accurate. If the status is returned (with patch 1), 
>> then it should have the SEEN_REPLY flag set. Another issue is that the 
>> accounting counters are not updated. IMHO this should be done as well 
>> (is not in my patches).
> 
> Fully agreed about the counters. About the SEEN_REPLY bit - that
> depends on how you define its meaning. So far its only set if
> a valid reply for the connection is seen - which a RST isn't.

I consider a RST as a valid reply for a connection. It matches the tuple 
and is in reply direction (ctinfo is set to IS_REPLY). Further the TCP 
protocol handler returns no error. The SEEN_REPLY bit is actually set at 
the end of nf_conntrack_in() but the destroy event is already triggered 
by the TCP handler.

Increasing the counters in reply direction without setting the 
SEEN_REPLY bit seems a bit weird to me.
