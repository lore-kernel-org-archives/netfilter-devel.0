From: Thomas Jacob <jacob@internet24.de>
Subject: Re: question about names as addresses in iptables
Date: Fri, 17 Apr 2009 15:24:33 +0200
Message-ID: <1239974673.6509.9.camel@enterprise.ims-firmen.de>
References: <885896af0904170602vdf7a448xd53d5e8642d14d90@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giacomo <delleceste@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:38946 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZDQNYg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:24:36 -0400
In-Reply-To: <885896af0904170602vdf7a448xd53d5e8642d14d90@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2009-04-17 at 15:02 +0200, Giacomo wrote:
> Is userspace iptables resolving names into ips and loading them into
> the kernel when i impart the command line
> and then are they left as they are into the kernel?

Yes.

> If an ip address changes its value, mantaining the same name, is it
> necessary to reload the rule?

Yes, as consequence of the above.


> If a name has more than one ip address (the name has aliases), are all
> the ip addresses loaded into the rule?

Subject to a few restrictions, a rule is inserted for each IP address
return by gethostbyname.

> (as an example www.google.com has three ips). If yes, how can I see
> the numeric values into the iptable rule?

The usual way iptables -L, if you want to switch off name resolution
just add an -n (as specified in the fine manual).

