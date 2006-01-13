From: Patrick McHardy <kaber@trash.net>
Subject: Re: new iptables policy match
Date: Fri, 13 Jan 2006 08:01:53 +0100
Message-ID: <43C75061.4080508@trash.net>
References: <925A849792280C4E80C5461017A4B8A26DAE@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Marco Berizzi <pupilla@hotmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
In-Reply-To: <925A849792280C4E80C5461017A4B8A26DAE@mail733.InfraSupportEtc.com>
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

Greg Scott wrote:
> Just to be completely anal because I'm just a skinny 
> bald guy from Minnesota - is this ASCII art right?
> If this is right, maybe this would make the man page
> even clearer.  Of course, if it's wrong, that means
> I still don't get it.
> 
> 
> LAN    FW   Internet   FW    LAN
> <----+----+----------+----+----->
>      |    |          |    |
> Private  Public   Public  Private
>     IP    IP        IP     IP
> 
>  Tunnel   SA        SA   Tunnel
>  endpoint                endpoint

No, the tunnel endpoints are the hosts using the tunnel-mode SA,
so in this case both firewalls.
