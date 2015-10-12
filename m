From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 2/3] ipv4: Pass struct net into ip_defrag and
 ip_check_defrag
Date: Mon, 12 Oct 2015 22:11:48 +0200
Message-ID: <20151012201148.GA12460@salvia>
References: <87bnca4aie.fsf_-_@x220.int.ebiederm.org>
 <1444416295-31683-2-git-send-email-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444416295-31683-2-git-send-email-ebiederm@xmission.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Oct 09, 2015 at 01:44:54PM -0500, Eric W. Biederman wrote:
> The function ip_defrag is called on both the input and the output
> paths of the networking stack.  In particular conntrack when it is
> tracking outbound packets from the local machine calls ip_defrag.
> 
> So add a struct net parameter and stop making ip_defrag guess which
> network namespace it needs to defragment packets in.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

For the netfilter chunk:

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
