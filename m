From: Joerg Mayer <jmayer@loplof.de>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 04:53:16 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020607045316.N11214@thot.informatik.uni-kl.de>
References: <E17G9Cc-00015Q-00@wagner.rustcorp.com.au>
Reply-To: netfilter-devel@lists.samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <E17G9Cc-00015Q-00@wagner.rustcorp.com.au>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 07, 2002 at 12:10:09PM +1000, Rusty Russell wrote:
> > If their firewall reboots and is running iptables and thus Linux: How
> > long will it be down?
> 
> 120 seconds to reboot with a fixed kernel...

Umm, OK, I shouldn't have compared the reboot time of my desktop pc
with a tuned firewall/router pc.

> > Which application will actually survive the down-time?
> 
> Everything: it's just like a router going down.

Yes, sure, but now let's look at where most (linux) firewalls are
deployed: As (or at) the gateway to the internet. Your typical traffic
there will consist of mail, web, p2p, ftp, online gaming, nntp and the
occasional telnet/ssh/...
Mail, p2p and nntp don't really care. If the connections breaks, so
what? Let's try again (application). Web: If the connection breaks, the
user will hit reload way before the firewall is back online; in addition
large transfers can be resumed in many cases. ftp: you are right,
although with current clients, reget and automatic retries are not
uncommon. Online gaming, telnet/ssh/... depend on whether you are
actively doing something when the connection goes down. If you do,
even two minutes is too long ususally. Either your app has thrown
you out with a ping timeout etc, or the user will become impatient
and kill the connection anyway.

> > Does this application really matter?
> 
> Um, does connectivity matter 8)

Sure, what I'm trying to say is, that in many (most) current uses,
connectivity matters. It matters so much though, that it doesn't
matter, whether packets belonging to active connections are dropped
or not after a two minute downtime. They are de facto dead too.

   ciao

PS: I'm the first who will admit, that there are other places/usages,
  where this will make a difference thouth, e.g. connecting Database
  Servers and clients through a firewall. If many client apps are
  idling, they will (hopefully) survive the downtime.
--
Joerg Mayer                                          <jmayer@loplof.de>
I found out that "pro" means "instead of" (as in proconsul). Now I know
what proactive means.
