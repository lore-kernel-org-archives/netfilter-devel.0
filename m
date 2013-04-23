From: "Fabio M. Di Nitto" <fdinitto@redhat.com>
Subject: Re: [Nftables RFC] High level library proposal
Date: Tue, 23 Apr 2013 09:27:47 +0200
Message-ID: <517637F3.3070704@redhat.com>
References: <516EA684.9040209@linux.intel.com>  <20130419100531.GA3481@localhost> <1366661111.26911.361.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Eric Leblond <eric@regit.org>,
	Julien Vehent <julien@linuxwall.info>,
	Jiri Benc <jbenc@redhat.com>,
	Daniel Borkmann <dborkman@redhat.com>,
	Thomas Graf <tgraf@redhat.com>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab3DWH2x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:28:53 -0400
In-Reply-To: <1366661111.26911.361.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jesper,

thanks for summarizing it and keep me in the loop.

On 4/22/2013 10:05 PM, Jesper Dangaard Brouer wrote:

Use-case 4
----------

I discussed this with Pablo after the conference (well I rather cornered
him and forced him to listen to me ;)).

Common per socket ACL re-using in kernel nftable.

Problem: virtually all userland daemons implement some kind of access
list (source ip, interface, etc.). This is a lot of duplicated code
across many implementations that might be not as efficient as they could
be and not as flexible.

Discussion lead to have some kind of per socket nftable that could (for
example):

1) drop packets directly (saves a few memcpy down to userland and
userland processing).

2) mark the packet as "this one matched rule X or Y" and send the data
down to userland in the ancillary data, to allow userland to warn/take
other actions.

and from a troubleshooting/debugging perspective, by having all those
rules in the place (nftable/kernel), would allow a user to:

nftable --fulldump (whatever option)

and see effectively all the rules that apply to the host and the
applications in one go, without having to interact with multiple parts
of the system (first nftable, then per application config files, etc).

An approach of this kind also integrates very well with use-case 2 and 3
because effectively, a dry run would be able to navigate all the active
rules at once.

Thanks again for taking time to listen to my rumbling guys!
Fabio
