From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Creation of a custom netfilter/iptables target module
Date: Tue, 8 Oct 2013 10:02:08 +0200
Message-ID: <20131008080208.GA3771@localhost>
References: <0d7e01cec3b5$dd64f100$982ed300$@telsatbb.vu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Steve (Telsat Broadband)" <steve@telsatbb.vu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53854 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab3JHICM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:02:12 -0400
Content-Disposition: inline
In-Reply-To: <0d7e01cec3b5$dd64f100$982ed300$@telsatbb.vu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 08, 2013 at 10:35:10AM +1100, Steve (Telsat Broadband) wrote:
> Hi All,
> 
> I'm seeking the wisdom of the netfilter gurus to get me going in the right
> direction.
> 
> Currently, we have a gateway in which several iptables/ip6tables rules send
> information to the LOG target which a custom perl script then reads to
> perform some processing on the sender's MAC and IP.
> 
> What I'm wanting to do is relieve load on the system by cutting out the step
> of logging to syslog and sending straight to the processing program either
> via a socket or some other means.  I don't need to store any of the
> information in the packet, only pass the MAC and IP (v4 or v6) to the
> processing program.

Did you consider ulogd2?

Regards.
