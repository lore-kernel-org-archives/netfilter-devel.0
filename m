From: Patrick Schaaf <bof@bof.de>
Subject: Re: Iptables 1.3.1 still not very fast.
Date: Sat, 2 Apr 2005 07:41:12 +0200
Message-ID: <20050402054112.GA20287@oknodo.bof.de>
References: <89b63d049739b257@mayday.cix.co.uk>
	<20050402124038.0201.LARK@linux.net.cn> <424E2E78.9010800@ufh.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Peter Enderborg <pme@ufh.se>
Content-Disposition: inline
In-Reply-To: <424E2E78.9010800@ufh.se>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> Maybe a dumb question. But how do you hash on a range?

Not a dumb question at all, but here's a dumb answer: you add each address
in the range. This is wholly practical for small ranges, and half way
practical for larger ranges which need to be configured only now and then.

Alternatively, in the context of ipset, you could implement a range or
set-of-ranges subtype of ipset, using suitable data structures,
which would be some kind of tree. For fully general set-of-ip-nets
matching, the data structure would most likely resemble what's used
in routing table implementations.

best regards
  Partick
