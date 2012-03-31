From: Amm Snort <ammdispose-snort@yahoo.com>
Subject: NFQUEUE target with --treat-accept-as-continue?
Date: Sat, 31 Mar 2012 22:09:42 +0800 (SGT)
Message-ID: <1333202982.55963.YahooMailNeo@web193402.mail.sg3.yahoo.com>
Reply-To: Amm Snort <ammdispose-snort@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm28-vm6.bullet.mail.sg3.yahoo.com ([106.10.151.149]:45508 "HELO
	nm28-vm6.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757462Ab2CaOJo convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Mar 2012 10:09:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello all,

I would like to suggest a feature (additional parameter) for NFQUEUE ta=
rget.

I am basically trying to use snort with NFQUEUE.

Basic iptables rule is somewhat like this:

iptables -A INPUT -i ppp1 -j NFQUEUE
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -j DROP

Idea is to pass all packets to snort first and then if snort detects tr=
ojan signature then
it can DROP (IPS) the packet (drop rule of snort). If snort detects por=
t scan it can
LOG but still ACCEPT (IDS) (alert rule of snort). If snort ACCEPTs the =
packet then
continue processing next rule.

On side note, this idea also reduces load on snort as it does not have =
to sniff every
packet coming on network card and also we can pass only selected packet=
s to snort.


This idea however, DOES NOT work because currently when QUEUE program (=
snort)
gives verdict as NF_ACCEPT, iptables STOPS processing further rules and
ACCEPTs the packet.

This actually becomes security risk because default snort rules DO NOT =
DO port blocking.
and ACCEPTs everything that is not EXPLICITLY dropped.

And hence NFQUEUE target indirectly becomes ACCEPT target for all packe=
ts and
full system gets exposed.

So my request and suggestion is to add additional parameter to NFQUEUE
say, --treat-accept-as-continue (or rule not matched)


which means, if QUEUE program returns NF_ACCEPT then instead of ACCEPTi=
ng
the packet, continue processing next rule. (as if rule did=A0 not match=
)


I know there is NF_REPEAT, but that will PASS packet through all proces=
ing again
and I will also have to do packet marking etc. Which is more like HACK =
instead of
sensible approach.

And to use NF_REPEAT I will need to change whole snort code and rules. =
Which is
impossible.

So please consider my suggestion. As it opens up many other possibiliti=
es as well.

Thank you,


PS:
We can also extend this suggesion further with one more parameter as
--treat-accept-as-return which becomes equivalent to RETURN target.

This way NF_QUEUE target becomes a place holder for ACCEPT, DROP,
RETURN, CONTINUE (rule not matched). This can have lots of possible use
with wide flexibility.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
