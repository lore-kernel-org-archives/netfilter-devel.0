From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 06 Jun 2002 21:28:38 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3CFFB7E6.1080103@cs.auc.dk>
References: <3CFF9A00.2070805@cs.auc.dk> <20020606195706.A21880@oknodo.bof.de> <3CFFAB1C.902@cs.auc.dk> <20020606211211.B21880@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org, netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf wrote:
> 
> That's your policy choice. I may have others, in other situations.

Well, you're right this is a choice. I was just a little bit surprised
that:

1) This choice has not been so well documented,
2) No alternative, except the PATCH-O-MATIC, was proposed to the user.

But, once again, this is my policy choice.


> Any sensible patch to the current documentation has a good chance of being
> applied immediately.

I think, it could help to just add in the Packet-filtering HOWTO,
section 7.3 (Filtering Specifications)  :

NEW

     A packet which creates a new connection _and_all_ACK_packets_.


It sounds to be fair enough. At least the user know what he's doing.


> Disabling the current behaviour is out of the question. iptables is used
> as-is in the field.

Well, at least the PATCH-O-MATIC can help to disable if you choose it.
:-/

> My personal "must have" reason is proper per-tcp-connection NAT, i.e. the
> ability to change rules without breaking already-active connections.
> 
> That's not dependant on reboot/pickup, so I probably personally wouldn't
> care in most setups where I used iptables' conntracking in the past.
> 
> But if I learned that such a radical change were imminent, I'd be very
> alert to recall where it may bite me in my "installed base", and I'd
> probably miss one or two.

Well, I won't fight for it. :-)

> all the best, and low jitter to your students' measurements

Thanks for them. :-)

Regards
-- 
Emmanuel

De gustibus non disputandum.
   -- Linus Torvalds
