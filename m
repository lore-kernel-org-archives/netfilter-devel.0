From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: TOS target broken wrt RFC 1349
Date: Thu, 29 Apr 2004 14:52:38 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0404291448500.5102@chris.camcom.co.uk>
References: <Pine.LNX.4.44.0404290113410.17188-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0404290113410.17188-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Henrik,

> If I am not mistaken network byte order defines the highest order bit as 
> bit 0... this is more obvious when looking at larger structures such as an 
> IP header and can be confusing when looking at a field which maps directly 
> to an octet like the IP TOS field.

OK, thank you for clearing that up for me. However, either tcpdump or the
kernel must be wrong, because when I set TOS to 0x02, tcpdump says that I
set the ECT bit! (I know you will all say that tcpdump is wrong :-)

> > Therefore, it appears that use of the iptables TOS target, which modifies
> > bits 1-5 using the constants defined inip.h, will have unexpected results,
> > corrupting the ECN flags and not setting the actual TOS flags to the 
> > expected values.
> 
> The TOS target allows you to manipulate the whole Type of Service octet as
> defined by STD 5 (RFC 791). As this target gives you full power to
> manipulate this field it is your responsibility to not mess around with
> bits in ways outside of their defined scope.

Well, it doesn't give you full power over the TOS octet, see ipt_TOS.c:

        if (tos != IPTOS_LOWDELAY
            && tos != IPTOS_THROUGHPUT
            && tos != IPTOS_RELIABILITY
            && tos != IPTOS_MINCOST
            && tos != IPTOS_NORMALSVC) {
                printk(KERN_WARNING "TOS: bad tos value %#x\n", tos);
                return 0;
        }

> Actually I think both Linux, tcpdump and the RFC are correct here. Just a 
> matter of different bit notions obfuscating matters.

I wasn't implying that the RFC was wrong :-) but tcpdump and the kernel 
disagree over the meanings of these bits. I will contact the tcpdump 
maintainers.

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
