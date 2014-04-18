From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: additional conntrack feature
Date: Fri, 18 Apr 2014 22:02:54 +0200
Message-ID: <20140418200254.GA5417@localhost>
References: <535046D9.3020602@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Donovan <doohara@cisco.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55610 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbaDRUDG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:03:06 -0400
Content-Disposition: inline
In-Reply-To: <535046D9.3020602@cisco.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 17, 2014 at 05:25:45PM -0400, Donovan wrote:
> Hi,
> 
> We are writing Proof Of Concept (POC) code to export (send) enhanced
> NetFlow based on conntrack events.

I guess you refer to IPFIX? We got some recent patches to get it
working in ulogd2.

> We've added some new minimal functionality to the kernel socket and
> netfilter-conntrack code.  This provides new information in the
> events as can be viewed by the conntrack program.
>
> We would like to send NetFlow based on the conntrack events and were
> wondering where to place such functionality. We would like such
> NetFlow to be sent by a service or daemon and we would like for this
> functionality to become open source. We have some questions:

> - Would it be acceptable to enhance conntrack-tools to send this NetFlow?
> - Like for instance placing it in the conntrackd daemon?
> - Or would it be OK to provide a new program alongside conntrack and
> conntrackd or the conntrack-tools to do this?

ulogd2 is the logging netfilter stub, so it's the right framework for
logging extensions IMO.
