From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 16:36:08 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206071636.08111.hno@marasystems.com>
References: <E17G9Cc-00015Q-00@wagner.rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.samba.org
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

Rusty Russell wrote:

> > If their firewall reboots and is running iptables and thus Linux: How
> > long will it be down?
>
> 120 seconds to reboot with a fixed kernel...

More like 20 seconds with a standard modular kernel for firewall boxes with a 
slimmed OS running on commodity hardware..

With a truly boot speed optimized system you can get down to about 10 seconds 
for a iptables based firewall from power on to running..

Regards
Henrik
