From: Thomas Jacob <jacob@internet24.de>
Subject: Re: ipt_ACCOUNT 1.15 released
Date: Mon, 20 Apr 2009 13:31:32 +0200
Message-ID: <1240227092.27336.35.camel@enterprise.ims-firmen.de>
References: <200904141744.57570.thomas.jarosch@intra2net.com>
	 <200904161834.17450.thomas.jarosch@intra2net.com>
	 <1239906586.26220.58.camel@enterprise.ims-firmen.de>
	 <200904201219.28011.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:32940 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZDTLbe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:31:34 -0400
In-Reply-To: <200904201219.28011.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2009-04-20 at 12:19 +0200, Thomas Jarosch wrote:
> On Thursday, 16. April 2009 20:29:46 Thomas Jacob wrote:
> > Also, in order to make IPv6 accounting practical, I would probably add
> > some sort of subnet accounting along the following lines.
> >
> > -j ACCOUNT --network 1234:4567::/32 --account_mask /64
> >
> > which would only account packets in --network, and count data
> > for a whole subnet instead of a single IP, as assigning single
> > IPv6 addresses to customers is kind of silly in an ISP environment.
> >
> > To collect data for single IPs just use --account_mask 128.
> 
> Well, for IPv4 you can alreay use "--src 172.16.0.0/16"
> and then do "-j ACCOUNT --addr 0.0.0.0/0" to merge
> the complete subnet into one single IP address.

Hmm, then maybe haven't understood your module yet.

If I specify "--src 172.16.0.0/16 -j ACCOUNT --addr 0.0.0.0/0 --tname
X", I was under the impression that I will get entries for each single
IP that somehow appears in packets that match --src 172.16.0.0/16
in table X. Potentially a huge number (if you are getting DDOSed ;).

Then of course I could add up all these entries and come up with a
number for the subnet. And if I want to account many subnets
(1000s) this way, I will need to add many such tables and rules. 

That will probably not scale well, I think. 

Or does your module work in a different way?

