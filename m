From: cranium2003 <cranium2003@yahoo.com>
Subject: Re: Urgent SNAT help required
Date: Mon, 9 May 2005 06:47:02 -0700 (PDT)
Message-ID: <20050509134702.30225.qmail@web41412.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Vinay Reddy <vinayvinay@gmail.com>, netfilter-devel@lists.netfilter.org
In-Reply-To: 6667
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

Hello Vinay,
         Thanks it works. I have now another problem.
I set a 4 computer LAN with configuration as 
HostA
eth0=> 192.168.1.100

Router1
eth0=>10.1.1.1
eth1=>192.168.1.1

Router2
eth0=>10.1.1.100
eth1=>172.16.1.1

HostB
eth0=>172.16.1.100

   I added following to iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 
iptables -A FORWARD -i eth0 -o eth1 -m state --state
ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
on both Routers as both have eth0 directly connected.
    Now,when i ping from HostA to HostB through
Router1 and Router2,Router1 has to SNAT and it did and
sends a ping to HostB with HostB receiving src ip of
ping packet as that Router1 but reverse pong packet
from HostB to HostA does not changes src ip at
Router2. why?
Thanks in advance.
regards,
cranium.
--- Vinay Reddy <vinayvinay@gmail.com> wrote:
> On 5/9/05, cranium2003 <cranium2003@yahoo.com>
> wrote:
> > hello,
> >          I want to execute my code at
> > NF_IP_POST_ROUTING. For that First i want to know
> > which functions are executing at
> NF_IP_POST_ROUTING
> > Hook. Then i have enabled SNAT and I have wrriten
> code
> > at NF_IP_POST_ROUTING but i want to get outgoing
> > packets' IP address as new one SNAT'ed IP address
> not
> > the one that is before SNAT? How can i do that?
> Execute your code after SNAT has finished.
> >          I observe that my code and SNAT are
> executing
> > at same HOOK NF_IP_POST_ROUTING. But my code is
> > executed first and then SANT is doen but how to
> > reverse that?
> Use the following while declaring an nf_hook_ops
> struct:
> struct nf_hook_ops post_route = {
>   {NULL, NULL},
>   post_route_handler,
>   THIS_MODULE,
>   PF_INET,
>   NF_IP_POST_ROUTING,
>   NF_IP_PRI_NAT_SRC +1,  // <--- This is important.
> It is the priority.
> };
> 
> Note that the last field gives the priority for this
> handler. The
> higher it is, the earlier it is executed.
> 
> HTH,
> Vinay
> 
> > regards,
> > cranium
> > 
> > Yahoo! Mail
> > Stay connected, organized, and protected. Take the
> tour:
> > http://tour.mail.yahoo.com/mailtour.html
> > 
> > 
> 
> 
> -- 
> "Debugging is twice as hard as writing the code in
> the first place.
> Therefore, if you write the code as cleverly as
> possible, you are,
> by definition, not smart enough to debug it." -
> Brian W. Kernighan
> 


		
Yahoo! Mail
Stay connected, organized, and protected. Take the tour:
http://tour.mail.yahoo.com/mailtour.html
