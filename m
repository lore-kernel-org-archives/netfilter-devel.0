From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Port forwarding with iptables
Date: Thu, 2 Sep 2004 10:28:21 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409021025440.17962@filer.marasystems.com>
References: <200409020414.i824Eh7e032212@xanadu.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?iso-8859-1?Q?KUCKAERTZ_R=E9gis_-_NVISION?= <regis@nvision.lu>
In-Reply-To: <200409020414.i824Eh7e032212@xanadu.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 1 Sep 2004, [iso-8859-1] KUCKAERTZ R=E9gis - NVISION wrote:

> $IPTABLES -t nat -A PREROUTING -p tcp --dst $HOST_IP --dport 3999 -j DN=
AT
> --to-destination $SERVER_IP:123

Ok.

>   This one should do the forwarding
>
> $IPTABLES -t nat -a POSTROUTING -p tcp --dst $SERVER_IP --dport 123 -j
> MASQUERADE
>
>   ... and this one should masquerade

This should probably be a SNAT.

Please describe your network in a little more detail. Is the station wher=
e=20
you are running NAT a router (two network cards, ISP on one side, interna=
l=20
stations on other side) or just a host on the network?

Are you trying to connect from the Internet to internal stations/servers=20
in your Network, or the other way around?

Regards
Henrik
