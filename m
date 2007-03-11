From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [NETFILTER]: tcp_conntrack: accept RST|PSH as valid
Date: Sun, 11 Mar 2007 18:43:07 +0100
Message-ID: <45F43FAB.2080901@netfilter.org>
References: <11736083633448-git-send-email-w@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org, kaber@trash.net, davem@davemloft.net
To: Willy Tarreau <w@1wt.eu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <11736083633448-git-send-email-w@1wt.eu>
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

Bonjour Willy,

Willy Tarreau wrote:
> This combination has been encountered on an IBM AS/400 in response
> to packets sent to a closed session. There is no particular reason
> to mark it invalid.

I wonder if it is time to document this stuff. Would an interface to
configurate valid TCP flags settings from userspace be too much? Of
course, we would have a default configuration setup for them.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
