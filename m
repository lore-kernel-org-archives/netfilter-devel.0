From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: TPROXY / DIVERT
Date: Fri, 10 Jul 2009 23:55:12 +1200
Message-ID: <4A572C20.8020807@treenet.co.nz>
References: <4A543BB2.5080906@treenet.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:51767
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZGJLzR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jul 2009 07:55:17 -0400
Received: from troja.treenetnz.com. (121-72-27-25.dsl.telstraclear.net [121.72.27.25])
	by treenet.co.nz (Postfix) with ESMTP id 6985F205315
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2009 23:55:15 +1200 (NZST)
In-Reply-To: <4A543BB2.5080906@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Amos Jeffries wrote:
> TPROXY is turning out alright for most of our users. The iptables and 
> kernel changes seem to work perfectly. Thanks a lot guys.
> 
> We are just working our way through how it needs to fit into various 
> other network toolchains and re-documenting.
> 
> 
> Two netfilter relevant questions have arisen:
> 
> The old one: How long until IPv6 TPROXY support is available?
> 
> 
> The new one: How to configure TPROXY on a bridge?
> 

Alright Nevermind the bridge Q. has been resolved now.

The IPv6 Q. is still open. hint, hint :)

Amos
Squid Project
