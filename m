From: Rob Radez <rob@osinvestor.com>
Subject: Re: [PATCH] Tiny ip_nat_snmp_basic fix
Date: Mon, 24 Jun 2002 08:08:38 -0400
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020624080838.L9029@osinvestor.com>
References: <20020623135117.K9029@osinvestor.com> <Mutt.LNX.4.44.0206242023230.14216-100000@blackbird.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Radez <rob@osinvestor.com>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: James Morris <jmorris@intercode.com.au>
Content-Disposition: inline
In-Reply-To: <Mutt.LNX.4.44.0206242023230.14216-100000@blackbird.intercode.com.au>; from jmorris@intercode.com.au on Mon, Jun 24, 2002 at 08:28:23PM +1000
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 24, 2002 at 08:28:23PM +1000, James Morris wrote:
> On Sun, 23 Jun 2002, Rob Radez wrote:
> 
> > Hi,
> > I looked at the pending patches page, tried to browse through the mailing
> > archives, and checked google, but didn't see if anyone had already addressed
> > this.
> 
> See http://marc.theaimsgroup.com/?l=linux-kernel&m=100909932003300&w=2
> 
> >  fini() in net/ipv4/netfilter/ip_nat_snmp_basic.c is marked __exit,
> > but on Sparc32 will fail to link into the kernel because of some btfixup
> > magic.
> 
> Can you please post the build error message and the version of binutils 
> that you're using?

This is slightly different: it's not ld complaining, but btfixup.
(background info: btfixup is a way for one kernel to run on sun4c/sun4d/sun4m
with the kernel determining all the hardware-specific functions to call at
boot time instead of compile time.)  When compiling for smp with the snmp
code builtin, btfixupprep complains "Wrong use of 'smp_processor_id' in
'.text.exit' section.  It can only be used in .text, .fixup and .text.init".
Of all the files that I compiled into the kernel, ip_nat_snmp_basic is the
only one that had this problem, so I figured that while the __exit tag is
correct, it was simplest to just remove it and suffer the miniscule loss of
not being able to free the memory it takes up.

> The purpose of this lock/unlock is to synchronize with net_rx_action().

Perhaps a comment in the code to that effect?

Regards,
Rob Radez
