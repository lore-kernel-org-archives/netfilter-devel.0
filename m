From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: event-driven connection tracking
Date: Wed, 13 Oct 2010 16:24:07 +0100
Message-ID: <4CB5CF17.3090302@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41753 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab0JMPYO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:24:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Is it possible to use event-driven connection tracking - with 
conntrack-utils or by other means?

Ideally, what I would like to do is 'register' a handler for particular 
connection events (when new connection is established and then closed 
for example) based on particular pre-defined filter (say, by protocol, 
source/destination ip etc) and execute a program code/function (if done 
programmatically) or a script (if done outside the connection-tracking 
domain) to do what I want?

Currently, the only way to track such 'events' is if I include a 
separate chain in iptables tracking a particular connection (and logging 
the event via a normal log jump), but that is not enough for me as I 
also need to trigger a full dump based on that particular 'filter' and 
end this dump when the connection is closed. Any ideas?
