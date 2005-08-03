From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] iptables redirect is broken on bridged setup
Date: Wed, 03 Aug 2005 03:46:40 +0200
Message-ID: <42F02200.1090802@trash.net>
References: <200507291209.37247.vda@ilport.com.ua>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Denis Vlasenko <vda@ilport.com.ua>
In-Reply-To: <200507291209.37247.vda@ilport.com.ua>
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

Denis Vlasenko wrote:
> Linux 2.6.12
> 
> Was running for months with this simple iptables rule:
> 
> iptables -t nat -A PREROUTING -s 172.17.6.44 -d 172.16.42.201 -p tcp --dport 9100 -j REDIRECT --to 9123
> 
> Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
>        0        0 REDIRECT   tcp  --  *      *       172.17.6.44          172.16.42.201      tcp dpt:9100 redir ports 9123
> 
> But now I need to bridge together two eth cards in this machine, and
> suddenly redirect is no longer works.

This doesn't look related to the nf_reset problem since it happens
in PREROUTING and only the output hooks are defered. I suspect a
configuration error, when there is no IP configured on a device
the REDIRECT target can't be used.
