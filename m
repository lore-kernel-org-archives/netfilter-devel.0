From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: iptables and martian filtering
Date: Wed, 6 Jun 2007 15:38:58 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706061535370.1547@yvahk01.tjqt.qr>
References: <d41814cf0706060625sa4f22efh478c5beb9f6693a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: pankaj jain <jainp1979@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <d41814cf0706060625sa4f22efh478c5beb9f6693a9@mail.gmail.com>
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



On Jun 6 2007 18:55, pankaj jain wrote:
>Subject: iptables and martian filtering

iptables -A INPUT -s mars -j DROP
iptables -A INPUT -m martian -j DROP

SCNR ;-)

> HI,
> I am learning how iptables work, so I was writing rules for PREROUTING
> chain in nat table
> I was trying to change the destination address in the incoming packet
> to 127.x.x.x IP.
> since my server is listening on that interface.

No. Every linux box always listens on all 16 million 127.0.0.0/8 addresses,
so trying to make it use something else than 127.0.0.1 is almost always
meaningless.

> I added following rules:
> iptables -I PREROUTING -t nat -p tcp -d 192.168.1.10 --dport 23456 -j
> DNAT --to-destination 127.0.0.3

DNAT to localhost does not work, use REDIRECT.

> iptables -I INPUT -p tcp -d 127.0.0.3 -j ACCEPT
> iptables -I INPUT -p tcp -i lo -j ACCEPT
> iptables -I OUTPUT -p tcp -s 127.0.0.3 -j ACCEPT
> iptables -I OUTPUT -p tcp -o lo -j ACCEPT
>
> server is listening on 127.0.0.3:23456
> client is trying to connect to 192.168.1.10:23456
>
> but client is not able to connect to the server
> I was getting logs such as "martian destination 127.0.0.3 from
> 192.168.1.10, dev eth0" in dmesg.
>
> I believe "Martian Address Filtering" is taking place.
> is there any way to override this filtering action ?
>
> -- 
> Thanks
> Pankaj Jain
>
>

	Jan
-- 
