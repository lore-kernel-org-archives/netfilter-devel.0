From: Joerg Mayer <jmayer@loplof.de>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 01:52:47 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020607015247.L11214@thot.informatik.uni-kl.de>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au>
Reply-To: netfilter-devel@lists.samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <E17G6im-0000FK-00@wagner.rustcorp.com.au>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 07, 2002 at 09:31:12AM +1000, Rusty Russell wrote:
> 	Of course, you can still use SYNs to scan the network, so they
> haven't actually won anything here, except that if their firewall
> reboots, established connections will die.

If their firewall reboots and is running iptables and thus Linux: How
long will it be down? Which application will actually survive the down-
time? Does this application really matter?

  Ciao
       Jörg

--
Joerg Mayer                                          <jmayer@loplof.de>
I found out that "pro" means "instead of" (as in proconsul). Now I know
what proactive means.
