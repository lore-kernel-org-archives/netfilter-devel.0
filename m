From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [NETFILTER]: tcp_conntrack: accept RST|PSH as valid
Date: Tue, 13 Mar 2007 17:19:45 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703131719070.18488@yvahk01.tjqt.qr>
References: <11736083633448-git-send-email-w@1wt.eu>
	<45F43FAB.2080901@netfilter.org> <45F6C882.2080103@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: davem@davemloft.net, netfilter-devel@lists.netfilter.org,
	Willy Tarreau <w@1wt.eu>, Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F6C882.2080103@trash.net>
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


On Mar 13 2007 16:51, Patrick McHardy wrote:
>Pablo Neira Ayuso wrote:
>> I wonder if it is time to document this stuff. Would an interface to
>> configurate valid TCP flags settings from userspace be too much? Of
>> course, we would have a default configuration setup for them.
>
>I don't think we need this. Flags are either valid for everyone or
>for nobody.

I agree. If you do not want certain TCP flag combinations, use iptables -j
DROP, no?

Jan
-- 
