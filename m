From: Brad Chapman <kakadu_croc@yahoo.com>
Subject: Re: ICMP reject types?
Date: Tue, 1 Oct 2002 04:13:50 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021001111350.15151.qmail@web10908.mail.yahoo.com>
References: <20021001100755.GC5609@aba.krakow.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Pawe³" Krawczyk <kravietz@aba.krakow.pl>
In-Reply-To: <20021001100755.GC5609@aba.krakow.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Mr. Krawczyk,

--- Pawe³ Krawczyk <kravietz@aba.krakow.pl> wrote:
> Maybe it's my ignorance, but I feel that REJECT target --reject-with
> option is somewhat broken - you can set icmp-net-prohibited or
> host-prohibited ICMP replies, which are discouraged and obsoleted by RFC
> 1812, but you cannot use 0/13 ICMP (Admin prohibited), which is the one
> recommended by the RFC. Can anyone comment?
> 

I can. I, and others, wrote patches to fix this problem, but they were rejected
because Harald couldn't find one which didn't threaten to break userspace<->kernel
synchroninity or introduce bugs or quirks into the behavior of iptables. If you 
need 0/13 ICMP packets in the REJECT target, I can send you an untested patch 
that will add it.

> -- 
> Pawe³ Krawczyk, Kraków, Poland  http://echelon.pl/kravietz/
> horses: http://kabardians.com/
> crypto: http://ipsec.pl/
>

Brad 


=====
Brad Chapman

Permanent e-mail: kakadu_croc@yahoo.com

__________________________________________________
Do you Yahoo!?
New DSL Internet Access from SBC & Yahoo!
http://sbc.yahoo.com
