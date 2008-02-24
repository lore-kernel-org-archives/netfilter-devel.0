From: Friedrich Euler <friedrich.euler@googlemail.com>
Subject: do not nat gre packets
Date: Sun, 24 Feb 2008 20:04:22 +0100
Message-ID: <47c1bfc1.0637560a.59d2.ffffbd8b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:27240 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbYBXTEf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Feb 2008 14:04:35 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1002875fga.17
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Feb 2008 11:04:34 -0800 (PST)
Content-Language: de
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello, 
  
I am currently using iptables version 1.2.7a and encountered the following
issue. When using a GRE (over ipsec) tunnel without the optional GRE key
field, Netfilter cannot find a unique tupel for all GRE packets. This makes
the connection tracking fail. The source code shows only a GRE over PPTP
implementation. My understanding is that I need to extend the iptables
implementation of version 1.2.7a to enable the connection tracking. Is this
true? Was this fixed in a version following 1.2.7a? 
  
I would appreciate any information on this. 
  
 
Kind regards,

Friedrich

