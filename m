From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 07 Jun 2002 12:10:09 +1000
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <E17G9Cc-00015Q-00@wagner.rustcorp.com.au>
References: <20020607015247.L11214@thot.informatik.uni-kl.de>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: Your message of "Fri, 07 Jun 2002 01:52:47 +0200."
             <20020607015247.L11214@thot.informatik.uni-kl.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20020607015247.L11214@thot.informatik.uni-kl.de> you write:
> On Fri, Jun 07, 2002 at 09:31:12AM +1000, Rusty Russell wrote:
> > 	Of course, you can still use SYNs to scan the network, so they
> > haven't actually won anything here, except that if their firewall
> > reboots, established connections will die.
> 
> If their firewall reboots and is running iptables and thus Linux: How
> long will it be down?

120 seconds to reboot with a fixed kernel...

> Which application will actually survive the down-time?

Everything: it's just like a router going down.

> Does this application really matter?

Um, does connectivity matter 8)

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
