From: Esteban <eribicic@sinectis.com>
Subject: Re: [NEW TARGET] MARKCB connection marking balancing
Date: 03 Mar 2003 12:31:11 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1046705471.2728.150.camel@debian>
References: <3E62AF18.8010000@zobniow.priv.pl>
	<200303031653.47644.fabrice@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: fabrice@netfilter.org
In-Reply-To: <200303031653.47644.fabrice@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

what is that nth? i couldnt find in iptables man page.
where can i find more information?
thanks,

ps: is there any diference between using -j SNAT --to-source and -j
MASQUERADE? ive got static ip address on my internet connection? 

cause ive got my internal network masqueraded and i try to use fwmarks
in preroutinng to route to another  gw i have (iproute2)..and it works
(packets goes from internal to destination over the gw i choose) but
they dont come back because nat is not applyed and ofcourse, internal
packets are not routeable packets (10.0.0.0/24)..any idea? that would be
a smooth solution for balance traffic.

On Mon, 2003-03-03 at 05:53, Fabrice MARIE wrote:
> 
> Dzien Dobre Maciek,
> 
> On Monday 03 March 2003 09:25, Maciek Zobniow wrote:
> > Hi all!
> >   This is my first message to this list and I want to annouce a first
> > version of my new netfilter module for connection tracking balancing.
> > First maybe I will try to describe what this target should do:
> > I made this as a solution for balancing connections from one LAN,
> > betewen a few providers links, but I think that is possible to find
> > another good usages for this target.
> > Idea is quite simply: each connection (yes, connection not packet) which
> > arrived to this target is marked. It recive one mark which is use for
> > marking all packets  from this connection. Marks are sharing by choosen
> > algorithm (for now I implemented RR, WRR and special one- basing on
> > amout of data for each mark for last 1000 packets).
> > [...]
> 
> Just out of curiosity, how different is that from using the nth match
> to do RR SNATting ?
> 
> [
> i.e, Taken from the example section of the patch:
> 
> iptables -t nat -A POSTROUTING -o eth0 -m nth --counter 7 --every 3 --packet 0 -j SNAT --to-source 10.0.0.5
> iptables -t nat -A POSTROUTING -o eth0 -m nth --counter 7 --every 3 --packet 1 -j SNAT --to-source 10.0.0.6
> iptables -t nat -A POSTROUTING -o eth0 -m nth --counter 7 --every 3 --packet 2 -j SNAT --to-source 10.0.0.7
> 
> This example evenly splits connections between the three SNAT addresses.
> ]
> 
> Using nth, we use the fact that only the first packet of connections need to be SNATed.
> This extension to the nth original patch was made by Richard. I haven't tried it myself yet though
> as I have only one ISP :-)
> 
> Have a nice day,
> 
> Fabrice.
> --
> Fabrice MARIE
> 
> "Silly hacker, root is for administrators"
>        -Unknown
> 
> 
