From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] NETFILTER: New PPTP helper
Date: Fri, 16 Sep 2005 00:44:30 +0200
Message-ID: <4329F94E.4060107@trash.net>
References: <20050915145406.GC17121@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050915145406.GC17121@rama.de.gnumonks.org>
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

Harald Welte wrote:
> NETFILTER: Add new PPTP conntrack and NAT helper

I noticed a number of problems, this first batch of patches
fixes the worst ones I hope. There's also one or two small
cleanup patches. I can't test them here, please review and
ACK/NACK for Dave.


[NETFILTER]: pptp helper: propagate errors instead of using -EIO in init 
functions
[NETFILTER]: pptp helper: fix expectation leaks
[NETFILTER]: Rename misnamed function
[NETFILTER]: pptp helper: use locked variants of ip_conntrack_find_* 
functions
[NETFILTER]: pptp helper: fix leaks when issuing expectations
[NETFILTER]: pptp helper: fix buffer overflow
[NETFILTER]: pptp helper: clean up conntrack_pptp_help() a bit
[NETFILTER]: pptp helper: missing expectation flags initialisation
