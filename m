From: Didier Tournier <Didier.TOURNIER@gemplus.com>
Subject: Re: RFC 2694 and iptables
Date: Tue, 05 Nov 2002 10:10:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DC78B1B.2050805@gemplus.com>
References: <20021105061017.25960.qmail@web40310.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Kevin,

I had a look to Bind9 documentation, but dont think that this will match 
our need.
Let me begin by explaining our need (with more details).
The application is a way to manage mobile servers in a private area.
We want to allow any client residing on the internet to connect any 
server in a private zone.
This could be done by using Bind9 but....
We also have to know that we have a lot of servers and only few public 
address (IPV4).
In the bind9 documentation I didn't saw the way to update the zone files 
dynamically (for the public adress of course), and the lonely way to 
predict a future connection can be done by the DNS itself.
(If there's a DNS query this is most of time to connect the host just 
after).
If I missed something in the Bind doc, let me know.
In the RFC 2694, the DNS request is used to predict that a connection 
will be required on a specific host, and to configure the NAT. The 
response TTL have also to be set (or reset) to 0.
Most of time, I compare that need with what a NAP-PT does, because 
there's a need for a DNS-ALG too.

So, my need is more technical about the way to build (compile and so on) 
such a module than other way to manage our need. So please if any of you 
could give me infos, it will be really usefull.

Didier Tournier
