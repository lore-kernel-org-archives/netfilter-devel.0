From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: TOS target broken wrt RFC 1349
Date: Thu, 29 Apr 2004 01:26:41 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404290113410.17188-100000@filer.marasystems.com>
References: <Pine.LNX.4.58.0404281230300.3120@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.58.0404281230300.3120@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 28 Apr 2004, Chris Wilson wrote:

> RFC 1349 [ftp://ftp.isi.edu/in-notes/rfc1349.txt] defines the use of the 
> TOS octet in the IP header as follows:
> 
>    The Type of Service octet consists of three fields:
> 
>                 0     1     2     3     4     5     6     7
>              +-----+-----+-----+-----+-----+-----+-----+-----+
>              |                 |                       |     |
>              |   PRECEDENCE    |          TOS          | MBZ |
>              |                 |                       |     |
>              +-----+-----+-----+-----+-----+-----+-----+-----+

If I am not mistaken network byte order defines the highest order bit as 
bit 0... this is more obvious when looking at larger structures such as an 
IP header and can be confusing when looking at a field which maps directly 
to an octet like the IP TOS field.

> It seems to me that the four bits which ip.h specifies for TOS flags are 
> bits 1-5, not bits 3-7, in the TOS octet. Bits 0 and 1 are currently 
> redefined by RFC 3168 [ftp://ftp.isi.edu/in-notes/rfc3168.txt] for use in 
> ECN.

Actually this is bits 6 & 7 (network order), which maps to the last bit of
the TOS field and the MBZ field above, or bits 0+1 in host order when 
reading the TOS octet alone.

> Therefore, it appears that use of the iptables TOS target, which modifies
> bits 1-5 using the constants defined inip.h, will have unexpected results,
> corrupting the ECN flags and not setting the actual TOS flags to the 
> expected values.

The TOS target allows you to manipulate the whole Type of Service octet as
defined by STD 5 (RFC 791). As this target gives you full power to
manipulate this field it is your responsibility to not mess around with
bits in ways outside of their defined scope.

> (tcpdump's interpretation of the ECT bit is also wrong under RFC 2481
> [ftp://ftp.isi.edu/in-notes/rfc2481.txt], since it uses bits 0-1 instead
> of 6-7 as mandated by the RFC for ECN).

Actually I think both Linux, tcpdump and the RFC are correct here. Just a 
matter of different bit notions obfuscating matters.

Regards
Henrik
