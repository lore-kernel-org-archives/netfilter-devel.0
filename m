From: Eric Leblond <eric@regit.org>
Subject: Re: [Nftables RFC] High level library proposal
Date: Tue, 23 Apr 2013 00:26:33 +0200
Message-ID: <1366669593.15660.9.camel@tiger2>
References: <516EA684.9040209@linux.intel.com>
	 <20130419100531.GA3481@localhost> <1366661111.26911.361.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Julien Vehent <julien@linuxwall.info>,
	Fabio Di Nitto <fdinitto@redhat.com>,
	Jiri Benc <jbenc@redhat.com>,
	Daniel Borkmann <dborkman@redhat.com>,
	Thomas Graf <tgraf@redhat.com>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59422 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab3DVW0x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Apr 2013 18:26:53 -0400
In-Reply-To: <1366661111.26911.361.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I agree on all points of this mail. Some comments below.

On Mon, 2013-04-22 at 22:05 +0200, Jesper Dangaard Brouer wrote:
> First of all, thanks Tomasz for proposing to write a high level API for
> nftables.

+1

> Note to cc'ed people not on the netfilter-devel list can follow the
> thread here:
> http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/46734
...

> Use-case 2
> -----------
> Think this was Fabio's use-case during the netfilter workshop.
> 
> An interface to dry run a packet through configured netfilter policy.
> 
> This would allow user space to figure out if a specific daemon or
> use-case can function in the configured environment.
> 
> The feature is primarily intended for debugging and troubleshooting
> purposes but can be extended later on, enabling daemons or daemon
> management tools to verify if the daemon is permitted to run in the
> configured specific environment.
> 
> I guess, we also would need some kernel changes for supporting this?

I think this point is really interesting. Being able to know for a given
packet (IP tuple + ifaces)if it will get dropped or accepted or NAted
(and with which transformation) could be really interesting.

A more advanced related feature could be to have a TRACE like result .  

By the way, I've encountered today a TRACE limitation related to this
point when debugging a firewall. I was investigating a NAT issue
relative to a REJECT rule and TRACE was not tracing the sent ICMP
message. And as for result, the NAT transformation made on the error
message was not visible. This kind of information would be really useful
if the test system is implemented.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

