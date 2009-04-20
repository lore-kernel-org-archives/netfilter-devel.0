From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ipt_ACCOUNT 1.15 released
Date: Mon, 20 Apr 2009 14:12:50 +0200
Message-ID: <200904201412.51270.thomas.jarosch@intra2net.com>
References: <200904141744.57570.thomas.jarosch@intra2net.com> <200904201219.28011.thomas.jarosch@intra2net.com> <1240227092.27336.35.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:34039 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbZDTMMy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 08:12:54 -0400
In-Reply-To: <1240227092.27336.35.camel@enterprise.ims-firmen.de>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday, 20. April 2009 13:31:32 Thomas Jacob wrote:
> > Well, for IPv4 you can alreay use "--src 172.16.0.0/16"
> > and then do "-j ACCOUNT --addr 0.0.0.0/0" to merge
> > the complete subnet into one single IP address.
>
> Hmm, then maybe haven't understood your module yet.
>
> If I specify "--src 172.16.0.0/16 -j ACCOUNT --addr 0.0.0.0/0 --tname
> X", I was under the impression that I will get entries for each single
> IP that somehow appears in packets that match --src 172.16.0.0/16
> in table X. Potentially a huge number (if you are getting DDOSed ;).

Yes, basically it works that way. The only exception is 0.0.0.0/0:

"A special subnet is "0.0.0.0/0": All data is stored in the src_bytes and 
src_packets structure of slot "0". This is useful if you want to account the 
overall traffic to/from your internet provider."

-> You can accumulate complete subnets on one entry if you like.

F.e. we use this to check for network activity
(=and decrase a timeout if not present).

Cheers,
Thomas

