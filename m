From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: ipsec with 2.6.16-rc3-git6
Date: Fri, 17 Feb 2006 10:26:36 +0100
Message-ID: <BAY103-F317BB3E7D40C47ECB8126EB2F80@phx.gbl>
References: <43F592DB.9090701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <43F592DB.9090701@trash.net>
To: kaber@trash.net
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


Patrick McHardy wrote:

>Marco Berizzi wrote:
> >
> > Patrick McHardy wrote:
> >
> >> Marco Berizzi wrote:
> >> > With these rules I'm able to send/receive packets from the two
> >> > private networks each other (172.16.0.0/23<->172.23.0.0/23).
> >> > If I delete the first rule in the INPUT table (on firenze-gateway)
> >> >
> >> > ACCEPT     all  --  venezia-gateway       0.0.0.0/0
> >> >
> >> > there is no packet flow inside the tunnel. I don't understand,
> >> > as I accept esp packets in the red-me chain.
> >>
> >> What does your policy look like?
> >
> >
> > root@Halley:~# ip xfrm policy
> > src 172.16.0.0/23 dst 172.23.0.0/23
> >        dir in priority 2377
> >        tmpl src venezia-gateway dst firenze-gateway
> >                proto comp reqid 16406 mode tunnel
> >                level use
> >        tmpl src 0.0.0.0 dst 0.0.0.0
> >                proto esp reqid 16405 mode transport
> > src 172.23.0.0/23 dst 172.16.0.0/23
> >        dir out priority 2377
> >        tmpl src firenze-gateway dst venezia-gateway
> >                proto comp reqid 16406 mode tunnel
> >        tmpl src 0.0.0.0 dst 0.0.0.0
> >                proto esp reqid 16405 mode transport
> > src 172.16.0.0/23 dst 172.23.0.0/23
> >        dir fwd priority 2377
> >        tmpl src venezia-gateway dst firenze-gateway
> >                proto comp reqid 16406 mode tunnel
> >                level use
> >        tmpl src 0.0.0.0 dst 0.0.0.0
> >                proto esp reqid 16405 mode transport
>
>I can't see a mistake. Can you please add a logging rule to log
>the packets that get dropped without the ACCEPT rule?

Sure! Here is:

root@Halley:/tmp# iptables -D INPUT -s venezia-gateway -j ACCEPT

[started ping from a venezia private host ----> to firenze private host]

root@Halley:/tmp# iptables -I INPUT -s venezia-gateway -j LOG --log-level 
debug --log-ip-options

IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=112 TOS=0x00 PREC=0x00 TTL=53 
ID=45921 PROTO=ESP SPI=0x583f3ff9
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=80 TOS=0x00 PREC=0x00 TTL=53 
ID=45921 PROTO=4
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=112 TOS=0x00 PREC=0x00 TTL=53 
ID=45922 PROTO=ESP SPI=0x583f3ff9
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=80 TOS=0x00 PREC=0x00 TTL=53 
ID=45922 PROTO=4
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=112 TOS=0x00 PREC=0x00 TTL=53 
ID=45923 PROTO=ESP SPI=0x583f3ff9
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=80 TOS=0x00 PREC=0x00 TTL=53 
ID=45923 PROTO=4
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=112 TOS=0x00 PREC=0x00 TTL=53 
ID=45924 PROTO=ESP SPI=0x583f3ff9
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=80 TOS=0x00 PREC=0x00 TTL=53 
ID=45924 PROTO=4
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=112 TOS=0x00 PREC=0x00 TTL=53 
ID=45925 PROTO=ESP SPI=0x583f3ff9
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=80 TOS=0x00 PREC=0x00 TTL=53 
ID=45925 PROTO=4
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=112 TOS=0x00 PREC=0x00 TTL=53 
ID=45926 PROTO=ESP SPI=0x583f3ff9
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=80 TOS=0x00 PREC=0x00 TTL=53 
ID=45926 PROTO=4
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=112 TOS=0x00 PREC=0x00 TTL=53 
ID=45927 PROTO=ESP SPI=0x583f3ff9
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=80 TOS=0x00 PREC=0x00 TTL=53 
ID=45927 PROTO=4
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=112 TOS=0x00 PREC=0x00 TTL=53 
ID=45928 PROTO=ESP SPI=0x583f3ff9
IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00 
SRC=venezia-gateway DST=firenze-gateway LEN=80 TOS=0x00 PREC=0x00 TTL=53 
ID=45928 PROTO=4
root@Halley:/tmp# iptables -D INPUT -s venezia-gateway -j LOG --log-level 
debug --log-ip-options
