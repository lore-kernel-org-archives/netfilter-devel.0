From: Patrick Schaaf <bof@bof.de>
Subject: Re: [More Question] TIMEBLOCK
Date: Thu, 10 Oct 2002 11:05:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021010090536.GA18299@oknodo.bof.de>
References: <CKEGJOPDOMNNFIGIMICAOEGPCBAA.caster@postech.ac.kr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: wizard <caster@postech.ac.kr>
Content-Disposition: inline
In-Reply-To: <CKEGJOPDOMNNFIGIMICAOEGPCBAA.caster@postech.ac.kr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>  3) When it is past 7 AM , the rule acceping telnet will be vanished by
> crond , but telnet session will be survive, because of it's session and
>  the rule accepting Established packet.

Who is forcing you to accept any established packet???

>  I want to apply drop rule to the connection still using.

A real drop would probably keep the conntrack entry sitting there
for a long time, so I would propose you use REJECT, instead, so
the endpoints of a TCP connection have a chance to notice your
timely hostility when it happens.

>  how can i do this  sustaining the Established accept rule on the top of
> FORWARD chain?

Again, who is forcing you to have an unconditional 'established' rule
on top of your forward chain?

I hope this could help you. If not, please ask again on the user mailing
list. This is no development question, all the features you need are
alreay there.

best regards
  Patrick

-- 
By the way, I'm all for Koreans learning iptables.
