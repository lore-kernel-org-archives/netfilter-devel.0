From: "Toshihiro Sonoda" <toshihiro@jp.fujitsu.com>
Subject: Re: [PATCH] update for ROUTE target in Netfilter-Extension HOWTO [ENG][FR]
Date: Sat, 21 Sep 2002 18:11:20 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <006b01c2614e$d9ed8300$fb01a8c0@monday>
References: <200209201617.g8KGHNfc009408@marajade.sandelman.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


hi, I have one question.

> 
>     >> I agree that the interaction with NAT is confusing at present.
> 
>     dric> The ROUTE target is now to be inserted in the mangle table.  This
>     dric> means that the ROUTE target applies before NAT (mangle table has
>     dric> higher priority than nat table, but lower than conntrack table).
>     dric> So there is no longer interactions with the NAT.
> 
>   NAT is done in POSTROUTING, unless you mean the un-NAT stuff, which I
> don't understand.
> 

I think NAT is not done in POSTROUTING in this case.

Packets, which are matched by the rule of 'ROUTE tareget',
flow as following route.

-> [mangle: PREROUTING]->[some tunnel device]->
         [OUTPUT]->[POSTROUTING]-> send to another machine.

The packets go through the POSTROUTING, but netfilter does not use 
the NAT tables matching rule in the POSTROUTING, because of 
hook of mangle tables.

Is that OK? or Do I mistake?

If I am right, I want to send masqueraded packets to ROUTE target.
 
