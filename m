From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Netfilter development project
Date: Wed, 13 Aug 2008 20:13:59 +0200
Message-ID: <48A32467.80703@netfilter.org>
References: <000501c8fd68$da840390$8f8c0ab0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Andy Loukes <andy@loukes.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52676 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751993AbYHMSjZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:39:25 -0400
In-Reply-To: <000501c8fd68$da840390$8f8c0ab0$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andy Loukes wrote:
> My company needs to develop two netfilter applications.
> 
> First a simple daemon which listens on a tcp socket for messages which
> inform it to add or remove specific iptables rules. It needs to be
> secure, very high performance and deal with multiple concurrent
> requests. We currently use iptables rules, but when I get time I'm going
> to try out using IPSet as it seems more appropriate.

I don't know if there exists something similar so far, but it should not
be hard to implement this.

> Second an accounting daemon, it needs to connect to another server using
> a to-be-defined protocol to update the packet and byte counts, in and
> out per source ip address.

I can extend ulogd [1] or the conntrack-tools [2] to do this, it should
not be hard either. Probably your company can sponsor this extension. We
can discuss the details in private.

[1] http://www.netfilter.org/projects/ulogd/index.html
[2] http://conntrack-tools.netfilter.org

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
