From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Any suggestions for getting a pcap of traffic over netlink?
Date: Tue, 22 Mar 2011 11:43:20 +0100
Message-ID: <4D887D48.6060100@netfilter.org>
References: <AANLkTi==4LicoDZ5JqY3YD7zSrh=E1GvPp5TJ33L5+_d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Sam Roberts <vieuxtech@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55529 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab1CVKnY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:43:24 -0400
In-Reply-To: <AANLkTi==4LicoDZ5JqY3YD7zSrh=E1GvPp5TJ33L5+_d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22/03/11 00:15, Sam Roberts wrote:
> Obviously, there is no net device to pcap - I'm wondering if anybody
> knows of ways to watch netlink traffic? I don't know netlink well, I'm
> wondering if its possible to do a PF_NETLINK socket that promiscuously
> receives all netlink traffic on all sockets?

This, or any similar feature, does not exist yet.

We can add some NETLINK_CONTROL family that would allows us to sniff all
netlink traffic.
