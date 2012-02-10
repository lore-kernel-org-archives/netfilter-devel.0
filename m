From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] DHCPv6 connection tracker helper
Date: Fri, 10 Feb 2012 12:18:01 +0100
Message-ID: <20120210111801.GA9827@1984>
References: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Darren Willis <djw@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44057 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab2BJLSJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:18:09 -0500
Content-Disposition: inline
In-Reply-To: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Darren,

On Fri, Feb 10, 2012 at 11:30:33AM +0900, Darren Willis wrote:
> Adds a connection tracker helper for DHCPv6, which relies on UDP
> multicast solicitations to discover DHCPv6 servers.
> 
> This allows DHCPv6 to work through ip6tables rulesets where
> non-related traffic is dropped (e.g., default fedora iptables).
> https://bugzilla.redhat.com/show_bug.cgi?id=656334

why not just adding the rule that allows udp traffic for this?

I still don't see the need for this extra module if you can get it
done with iptables itself.
