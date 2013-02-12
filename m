From: Jiri Pirko <jiri@resnulli.us>
Subject: team driver MAC NAT
Date: Tue, 12 Feb 2013 15:02:47 +0100
Message-ID: <20130212140247.GB18057@minipsycho.orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, edumazet@google.com,
	bart.de.schuymer@pandora.be, stephen@networkplumber.org,
	pablo@netfilter.org, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:58762 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317Ab3BLOC5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:02:57 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so54743eek.25
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Feb 2013 06:02:56 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all.

I have following situation:

host X  .............  eth0 -> br0 <- team0 <- eth2  ..............  switch  .........  host Z
host Y  .............  eth1 ---^         ^---- eth3  .................^

Now to achieve RX traffic balancing on team0, I have to mangle src mac of
all outgoing packets. If the packet goes through eth2, src mac will be set to
eth2 mac, same happens on eth3. I have to magle ARP packets as well.

This would achieve something which might be called "MAC NAT".

To unmangle RXed packets back to the original MAC adresses (of host X and host Y)
I need to track "connections".

Now the question is: Should this be integrated in netfilter infrastructure?
I'm thinking something similar to existing conntrack. NF_HOOK will be placed
in team driver rx/tx functions (similar to what bridge does).

I think this would be nicer than to do it independently just in team driver code.
Also this MAC NAT (with tracking connections, unlike what bridge MAC NAT does)
can be probably handy for other purposes as well (not sure what)

Thanks for any suggestions.

Jiri
