From: rui.sousa@mindspeed.com
Subject: TCP proto info
Date: Wed, 1 Sep 2010 15:45:52 +0200
Message-ID: <OF9D26EAF2.D88996EC-ONC1257791.00499961-C1257791.004BB4FC@mindspeed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail172.messagelabs.com ([216.82.254.3]:35033 "HELO
	mail172.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754255Ab0IANq6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:46:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have an application using libnetfilter_conntrack-0.100 that started 
reporting errors after the commit: 

1c450e1595afdc8d1bfabb4f640c9251808426eb.

I've checked that the error happens because the kernel sees an empty 
CTA_PROTOINFO attribute when parsing a conntrack update.
In the case of my application I was just trying to update the timeout of a 
TCP conntrack and so I didn't specify any of the TCP protoinfo attributes. 
With the previous library version no CTA_PROTOINFO attribute was set in 
the conntrack and no error was seen (this is valid from the point of view 
of the kernel). Now, an error is reported and the netlink command ignored.
What do you think would be the right fix? Should the commit be reverted? 
Or is the application obliged to specify attributes which it doesn't want 
to modify (and introduce possible race conditions since it's usually a 
read/write/modify)?

Br,
Rui

