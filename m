From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: Security flaw in Stateful filtering ??????
Date: 07 Jun 2002 14:45:21 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <veadq7uuji.fsf@inigo.ingate.se>
References: <E17G9Cc-00015Q-00@wagner.rustcorp.com.au>
	<20020607045316.N11214@thot.informatik.uni-kl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <20020607045316.N11214@thot.informatik.uni-kl.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Joerg Mayer <jmayer@loplof.de> writes:

> On Fri, Jun 07, 2002 at 12:10:09PM +1000, Rusty Russell wrote:
> > > If their firewall reboots and is running iptables and thus Linux: How
> > > long will it be down?
> > 
> > 120 seconds to reboot with a fixed kernel...
> 
> Umm, OK, I shouldn't have compared the reboot time of my desktop pc
> with a tuned firewall/router pc.

You call 120 seconds tuned?
My Linux firewall at home is up with forwarding and SSH-server running
20 seconds after hitting the reset button...

> telnet/ssh/... depend on whether you are
> actively doing something when the connection goes down. If you do,
> even two minutes is too long ususally. Either your app has thrown
> you out with a ping timeout etc, or the user will become impatient
> and kill the connection anyway.

Wrong. I always have several ssh-sessions, often with tunnels,
which I really prefer not to restart even if the network goes down
for several minutes.

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Firewall Developer, Ingate Systems AB |  http://www.ingate.com/
