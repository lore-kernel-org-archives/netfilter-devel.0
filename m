From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: iptables as a state machine
Date: Mon, 04 Oct 2004 08:51:51 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096905111.27100.0.camel@localhost.localdomain>
References: <20040930193955.6fa24afc.davem@davemloft.net>
	<61687.63.170.215.71.1096602469.squirrel@www.osdl.org>
	<415E6A86.6040707@drugphish.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@drugphish.ch>
In-Reply-To: <415E6A86.6040707@drugphish.ch>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2004-10-02 at 10:44 +0200, Roberto Nibali wrote:
> > Have you looked at nf-hipac.  It works and is fast but is limited
> > to 2.4 right now.  It's on my to do list...
> 
> I've started porting it as well, except a few locking issues and some 
> Makefile hazzle I should be done with it. I can send it to you in private.

Great, I planned to convert it to RCU and get rid of the netdevice
unregister changes.
