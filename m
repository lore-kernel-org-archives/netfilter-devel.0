From: James Morris <jmorris@intercode.com.au>
Subject: Re: [PATCH] Tiny ip_nat_snmp_basic fix
Date: Mon, 24 Jun 2002 20:28:23 +1000 (EST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Mutt.LNX.4.44.0206242023230.14216-100000@blackbird.intercode.com.au>
References: <20020623135117.K9029@osinvestor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Rob Radez <rob@osinvestor.com>
In-Reply-To: <20020623135117.K9029@osinvestor.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 23 Jun 2002, Rob Radez wrote:

> Hi,
> I looked at the pending patches page, tried to browse through the mailing
> archives, and checked google, but didn't see if anyone had already addressed
> this.

See http://marc.theaimsgroup.com/?l=linux-kernel&m=100909932003300&w=2

>  fini() in net/ipv4/netfilter/ip_nat_snmp_basic.c is marked __exit,
> but on Sparc32 will fail to link into the kernel because of some btfixup
> magic.

Can you please post the build error message and the version of binutils 
that you're using?

>  I saw two obvious ways to fix this, but only did one because I wasn't
> sure about what kind of netfilter magic is going on in fini().  The attached
> patch simply removes the __exit tag from fini() and lets the file link in ok.
>

No, the __exit tag is correct.

> 
> The other option is to remove the br_write_lock_bh/br_write_unlock_bh calls
> in fini() since they don't seem to be protecting anything.  I didn't do that
> because I'm not sure if there are any side effects that are being taken
> advantage of here.

The purpose of this lock/unlock is to synchronize with net_rx_action().


- James
-- 
James Morris
<jmorris@intercode.com.au>
