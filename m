From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix RST handling in ip_conntrack_proto_tcp.c
Date: Mon, 03 Jan 2005 00:21:53 +0100
Message-ID: <41D88211.1050202@trash.net>
References: <1104511137.3821.20.camel@tux.rsn.bth.se>	<Pine.LNX.4.58.0501011551420.15783@blackhole.kfki.hu>
	<1104593032.3821.25.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1104593032.3821.25.camel@tux.rsn.bth.se>
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

Martin Josefsson wrote:

>On Sat, 2005-01-01 at 15:59 +0100, Jozsef Kadlecsik wrote:
>
>>I think your patch should  be submitted immediately. The introduced bug is
>>too bad to leave it linger on.
>>
>
>I'll submit it to Andrew since Davem is on vacation.
>
The patch hasn't shown up in Linus's tree yet. I'm going to add it to
my tree and push it to Dave with the other patches if it didn't show up
by Tuesday.

Regards
Patrick
