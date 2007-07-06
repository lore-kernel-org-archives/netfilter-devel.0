From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
 interface?
Date: Fri, 06 Jul 2007 09:14:21 +0900 (JST)
Message-ID: <200707060014.l660EMSv000026@toshiba.co.jp>
References: <468C86C9.7050204@quo.to>
	<200707051117.l65BHBA6013655@toshiba.co.jp>
	<468CE260.2040500@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jr-list-2007@quo.to, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <468CE260.2040500@trash.net>
	<200707050111.l651Bu2w016010@toshiba.co.jp>
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

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 05 Jul 2007 14:21:52 +0200

> Yasuyuki KOZAKAI wrote:
> > From: Jordan Russell <jr-list-2007@quo.to>
> > Date: Thu, 05 Jul 2007 00:51:05 -0500
> > 
> > 
> >>Yasuyuki KOZAKAI wrote:
> >>
> >>>>Jul  4 14:54:33 webby kernel: [packet out wrong interface] IN= OUT=eth1
> >>>>SRC=123.23.23.23 DST=192.168.0.133 LEN=68 TOS=0x00 PREC=0xC0 TTL=64
> >>>>ID=39698 PROTO=ICMP TYPE=3 CODE=3 [SRC=192.168.0.133 DST=123.23.23.23
> >>>>LEN=40 TOS=0x00 PREC=0x20 TTL=239 ID=39262 PROTO=TCP SPT=25000 DPT=25000
> >>>>WINDOW=64172 RES=0x00 RST URGP=0 ]
> >>>>
> >>BTW: does the LOG output indicate that netfilter translated the source
> >>address of 70.243.226.250 to 192.168.0.133? If so, shouldn't it have
> >>instead translated the *destination* address of 123.23.23.23 (=eth1) to
> >>192.168.0.133? Could this be why the ICMP packet was generated in the
> >>first place?
> 
> > Hmmm, REJECT in your rule might generate it, but I'm not sure.
> 
> 
> Its pretty certain the REJECT target, it defauls to port unreachable
> and the network stack doesn't generate port unreachables for TCP.
> Jordan, please post your ruleset.

He has already posted it. REJECT is in INPUT chain. This means TCP packet
was not mangled. TCP packet might be handled as error, but there seemed to
be no log "nf_ct_tcp: ...".

Jordan, is there the message "nf_conntrack: table full, dropping packet"
in your log ? I've heard that BitTorrent creates huge connections.

> > *nat
> > :PREROUTING ACCEPT [32:2910]
> > :POSTROUTING ACCEPT [29:2330]
> > :OUTPUT ACCEPT [2:152]
> > -A PREROUTING -i eth1 -p tcp -m tcp --dport 25000 -j DNAT
> > --to-destination 192.168.0.133
> > -A PREROUTING -i eth1 -p udp -m udp --dport 25000 -j DNAT
> > --to-destination 192.168.0.133
> > -A POSTROUTING -o eth1 -j MASQUERADE
> > COMMIT
> > *filter
> > :INPUT DROP [0:0]
> > :FORWARD DROP [0:0]
> > :OUTPUT DROP [0:0]
> > -A INPUT -i lo -j ACCEPT
> > -A INPUT -i eth0 -j ACCEPT
> > -A INPUT -i eth1 -m state --state ESTABLISHED -j ACCEPT
> > -A INPUT -i eth1 -j REJECT --reject-with icmp-port-unreachable
> > -A INPUT -j DROP
> > -A FORWARD -j ACCEPT
> > -A OUTPUT -o lo -j ACCEPT
> > -A OUTPUT -d 192.168.0.0/255.255.255.0 -o eth0 -j ACCEPT
> > -A OUTPUT -d 192.168.0.0/255.255.255.0 -j LOG --log-prefix "[packet out
> > wrong interface] "
> > -A OUTPUT -o eth1 -j ACCEPT
> > -A OUTPUT -j DROP
> > COMMIT

-- Yasuyuki Kozakai
