From: Pablo Neira <pablo@eurodev.net>
Subject: Re: bug in icmp tracking?
Date: Tue, 09 Mar 2004 22:02:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404E30EE.4010600@eurodev.net>
References: <404E1E90.3060509@eurodev.net> <1078865277.3615.34.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <1078865277.3615.34.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martin,

Martin Josefsson wrote:

>You probably won't see them in /proc/net/ip_conntrack since they are
>removed as soon as the reply has been seen, which probably is around 1ms
>after you were added, you have to be quite lucky in order to see them in
>that file.
>  
>
Actually, this was my error, looking at /proc/net/ip_conntrack, this got 
me confused.

thanks,
Pablo
