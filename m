From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter_queue reinjecting packets
Date: Sun, 12 Mar 2006 20:35:40 +0100
Message-ID: <4414780C.60907@trash.net>
References: <1142119489.2987.61.camel@localhost>	<20060312151054.5a2020ad.aton@packetdropped.org>	<441433C2.6010901@trash.net>
	<20060312202133.08f8d8ee.aton@packetdropped.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: aton <aton@packetdropped.org>
In-Reply-To: <20060312202133.08f8d8ee.aton@packetdropped.org>
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

aton wrote:
>>nfnql_test already reinjects packets by the call to nfq_issue_verdict.
>>It seems you need to read the documentation ..
>>
> 
> sorry, but i cannot find any call to nfq_issue_verdict in this file.
> perhaps you mean nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL); ?

Yes, thats what I meant.

> i thought nfq_set_verdict was used to specify a handling routine for the packets... in the case of nfq_test.c set the handling routine for packets to the print_pkt() function.
> am i wrong?

Yes. nfq_set_verdict is used to tell the kernel to pass the packet
on and possibly exchange it. Both print_pkt and nfq_set_verdict
are called from the packet callback in the example code.

> what documentation? i would _love_ to read some documentation about libnetfilter_queue. 
> i have looked through http://netfilter.org/documentation/index.html#documentation-howto but i cannot find anything specific about libnetfilter_queue...

I don't think there is specific libnetfilter_queue documentation yet
(but its very simple and exports only a few functions, look at the
code). But we have ip_queue documentation, which should at least
help you understand it better conceptually.
