From: Kevin McConnell <kevymac@yahoo.com>
Subject: Re: RFC 2694 and iptables
Date: Tue, 5 Nov 2002 11:26:31 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021105192631.82028.qmail@web40301.mail.yahoo.com>
References: <3DC78B1B.2050805@gemplus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Didier Tournier <Didier.TOURNIER@gemplus.com>
In-Reply-To: <3DC78B1B.2050805@gemplus.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--- Didier Tournier <Didier.TOURNIER@gemplus.com>
wrote:

> The application is a way to manage mobile servers in
> a private area.
> We want to allow any client residing on the internet
> to connect any 
> server in a private zone.
> This could be done by using Bind9 but....
> We also have to know that we have a lot of servers
> and only few public 
> address (IPV4).
> In the bind9 documentation I didn't saw the way to
> update the zone files 
> dynamically (for the public adress of course), and
> the lonely way to 
> predict a future connection can be done by the DNS
> itself.

You mean that you want to be able to assign fully
qualified domain names to mobile hosts on the
internet, dynamically no matter where they connect
from but you want to be able to make sure that only
those hosts which are allowed to do this have
authority to do this. Does this sound correct? If so,
then you can do this without an IPtables module. Your
solution is to setup bind on the mobile hosts
themselves and allow them to connect to your
nameservers using rndc keys.

> If I missed something in the Bind doc, let me know.
> In the RFC 2694, the DNS request is used to predict
> that a connection 
> will be required on a specific host, and to
> configure the NAT. The 
> response TTL have also to be set (or reset) to 0.
> Most of time, I compare that need with what a NAP-PT
> does, because 
> there's a need for a DNS-ALG too.

Are you saying that your mobile hosts are going to
connect to your internal network using assigned RFC
1918 addresses via ppp or something like this... I am
still unsure of what you are trying to accomplish, but
I am sure that if you check out the bind-* lists you
might find some more useful help there....


=====
Kevin C. McConnell --RHCE-- <Red Hat Certified Engineer>

__________________________________________________
Do you Yahoo!?
HotJobs - Search new jobs daily now
http://hotjobs.yahoo.com/
