From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Thu, 30 Jun 2005 03:53:37 +0200
Message-ID: <42C350A1.1030602@trash.net>
References: <42C03F2E.30706@eurodev.net> <42C0806E.3010400@trash.net>
	<20050628071308.GE13239@sunbeam.de.gnumonks.org>
	<42C1747A.3010703@trash.net> <42C2F2DF.7070301@eurodev.net>
	<42C2FC14.80609@trash.net> <42C33E33.7090908@eurodev.net>
	<42C34445.9020709@trash.net>
	<20050630014901.GH16076@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20050630014901.GH16076@postel.suug.ch>
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

Thomas Graf wrote:
> * Patrick McHardy <42C34445.9020709@trash.net> 2005-06-30 03:00
> 
>>You add a new nfattr header with the type set to CTA_TUPLE and
>>note the position of skb->tail. Then you add the nested attributes
>>as usual. When you're done you set the length of the nfattr header
>>to skb->tail - old_tail. The RTA_NEST/RTA_NEST_END macros handle
>>this for rtnetlink (include/linux/rtnetlink.h).
> 
> 
> At some point we should introduce a "generic" attribute
> architecture for all netlink families. The connector
> stuff will need it as well, so maybe the time has come
> to actually do it.

I agree, most of the macros are just copied without modification
anyway. One more thing I would like to change is the excessive
use of RTA_PUT with structures on the stack. Using __RTA_PUT
and putting together these structures in-place would be much
nicer. nfnetlink has copied this part of rtnetlink.

Regards
Patrick
