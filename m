From: Fabrice MARIE <fabrice@netfilter.org>
Subject: Re: [NEW TARGET] MARKCB connection marking balancing
Date: Mon, 3 Mar 2003 16:53:47 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303031653.47644.fabrice@netfilter.org>
References: <3E62AF18.8010000@zobniow.priv.pl>
Reply-To: fabrice@netfilter.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Richard Wagner <rwagner@cloudnet.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: maciek@zobniow.priv.pl, netfilter-devel@lists.netfilter.org
In-Reply-To: <3E62AF18.8010000@zobniow.priv.pl>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Dzien Dobre Maciek,

On Monday 03 March 2003 09:25, Maciek Zobniow wrote:
> Hi all!
>   This is my first message to this list and I want to annouce a first
> version of my new netfilter module for connection tracking balancing.
> First maybe I will try to describe what this target should do:
> I made this as a solution for balancing connections from one LAN,
> betewen a few providers links, but I think that is possible to find
> another good usages for this target.
> Idea is quite simply: each connection (yes, connection not packet) which
> arrived to this target is marked. It recive one mark which is use for
> marking all packets  from this connection. Marks are sharing by choosen
> algorithm (for now I implemented RR, WRR and special one- basing on
> amout of data for each mark for last 1000 packets).
> [...]

Just out of curiosity, how different is that from using the nth match
to do RR SNATting ?

[
i.e, Taken from the example section of the patch:

iptables -t nat -A POSTROUTING -o eth0 -m nth --counter 7 --every 3 --packet 0 -j SNAT --to-source 10.0.0.5
iptables -t nat -A POSTROUTING -o eth0 -m nth --counter 7 --every 3 --packet 1 -j SNAT --to-source 10.0.0.6
iptables -t nat -A POSTROUTING -o eth0 -m nth --counter 7 --every 3 --packet 2 -j SNAT --to-source 10.0.0.7

This example evenly splits connections between the three SNAT addresses.
]

Using nth, we use the fact that only the first packet of connections need to be SNATed.
This extension to the nth original patch was made by Richard. I haven't tried it myself yet though
as I have only one ISP :-)

Have a nice day,

Fabrice.
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown
