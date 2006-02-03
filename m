From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: view nat mappings
Date: Fri, 03 Feb 2006 17:33:00 +0100
Message-ID: <43E385BC.8010807@eurodev.net>
References: <43E21484.3060400@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: sclark46@earthlink.net
In-Reply-To: <43E21484.3060400@earthlink.net>
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

Stephen Clark wrote:
> Does iptables have the capability to list out the actual nat
> mappings/translations,
> not just the rules that are currently active -
> similar to the way FreeBSD's ipfilter/ipnat does?

So, if I understood well, you want to get only current nat'ted
connections, right?

If so, this is fairly easy to implement in the conntrack tool. Something
like `conntrack -L nat` to show all current nat'ed connections. Is this
really of interest for everyone?

-- 
Pablo
