From: Thomas Graf <tgraf@suug.ch>
Subject: Re: Unable to build iptables on linux kernel 2.6.10 + 2.6.11-rc2
	+	2.6.11-rc2-bk5
Date: Tue, 1 Feb 2005 01:51:33 +0100
Message-ID: <20050201005133.GJ31837@postel.suug.ch>
References: <200501271553.j0RFr747004108@StraightRunning.com>
	<41FD5F3C.1060009@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Colin Harrison <colin.harrison@virgin.net>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <41FD5F3C.1060009@eurodev.net>
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

>  		/* The protocol. */
> -		u8 protonum;
> +		u_int8_t protonum;
>  
>  		/* The direction (for tuplehash) */
> -		u8 dir;
> +		u_int8_t dir;

I think __u8 would be a better choice.
