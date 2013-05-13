From: Dmitry Popov <dp@highloadlab.com>
Subject: Re: [PATCH] xtables-addons: xt_RAWNAT: skb writable part might not
 include whole l4 header (ipv4 case).
Date: Mon, 13 May 2013 13:50:20 +0400
Message-ID: <20130513135020.ea2e50fc6327fb3ffe9cb667@highloadlab.com>
References: <20130505220504.1a3f2380a1e798b37e628dd1@highloadlab.com>
	<20130505222433.5c27056103b98340bba773df@highloadlab.com>
	<alpine.LNX.2.01.1305081322250.29391@nerf07.vanv.qr>
	<20130508191202.4cb5233820bbb96a1e611329@highloadlab.com>
	<alpine.LNX.2.01.1305082320440.21875@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60443 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3EMJuf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 May 2013 05:50:35 -0400
Received: by mail-ee0-f48.google.com with SMTP id c4so3114225eek.21
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2013 02:50:34 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1305082320440.21875@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 8 May 2013 23:32:16 +0200 (CEST)
Jan Engelhardt <jengelh@inai.de> wrote:

> The only way to solve the NAT problem is to do without it.
> Full NAT is not simple at all, it requires DPI.
> RAWNAT is just a dumb l3addr replacer and does not help
> getting multi-connection sessions (such as 959ish FTP) going.

Well, in means of full nat - yes. I have no statistics of how people use 
nf_nat/xt_RAWNAT, but in my tasks I have a lot of packets that do not need DPI.
xt_RAWNAT works great and nf_nat led to packet loss. It probably was because
of main conntrack lock. Yes, I read it was removed not long ago, and haven't 
tested it since then, but anyway I do not want to use such a monster just to 
change 2-3 fields of packet. Just an use case, decision is up to you =).
