From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: tcp_conntrack: accept RST|PSH as valid
Date: Tue, 13 Mar 2007 16:51:30 +0100
Message-ID: <45F6C882.2080103@trash.net>
References: <11736083633448-git-send-email-w@1wt.eu>
	<45F43FAB.2080901@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org, Willy Tarreau <w@1wt.eu>,
	davem@davemloft.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F43FAB.2080901@netfilter.org>
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

Pablo Neira Ayuso wrote:
> I wonder if it is time to document this stuff. Would an interface to
> configurate valid TCP flags settings from userspace be too much? Of
> course, we would have a default configuration setup for them.

I don't think we need this. Flags are either valid for everyone or
for nobody.
