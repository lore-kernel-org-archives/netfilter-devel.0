From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.4+2.6] fix DELETE_LIST netfilter oopses
Date: Mon, 29 Mar 2004 20:29:10 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040329202910.78f5608f.davem@redhat.com>
References: <20040329113239.GC7039@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040329113239.GC7039@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 29 Mar 2004 13:32:39 +0200
Harald Welte <laforge@netfilter.org> wrote:

> We've now narrowed down the issue of kernel oopses in combination with
> 'LIST_DELETE' syslog messages happening in certain setups.
> 
> Apparently people who do not enable CONFIG_IP_NF_NAT_LOCAL and do
> DNAT/REDIRECT and want to connect locally from the gateway via DNAT to
> the DNAT'ed address experience the bug ;)
> 
> Please push the attached patch [courtesy of KOVACS Krisztian and Henrik
> Nordstrom] to 2.4.x and 2.6.x ASAP, thanks.  

Applied, thanks guys.
