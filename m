From: Glen Turner <glen.turner@aarnet.edu.au>
Subject: Re: TOS target broken wrt ECN (was RFC 1349)
Date: Fri, 30 Apr 2004 18:55:27 +0930
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1083317127.12783.71.camel@andromache>
References: <Pine.LNX.4.44.0404290113410.17188-100000@filer.marasystems.com>
	 <Pine.LNX.4.58.0404291748430.5102@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
   Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.58.0404291748430.5102@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2004-04-30 at 03:01, Chris Wilson wrote:

> Sorry to bother you again, but based on the information in the RFCs 
> (condensed):
> 
>   RFC 1349:
> 
>          0     1     2     3     4     5     6     7
>       +-----+-----+-----+-----+-----+-----+-----+-----+
>       |   PRECEDENCE    |          TOS          | MBZ |
>       +-----+-----+-----+-----+-----+-----+-----+-----+

>   RFC 3168:
> 
>          0     1     2     3     4     5     6     7
>       +-----+-----+-----+-----+-----+-----+-----+-----+
>       |          DS FIELD, DSCP           | ECN FIELD |
>       +-----+-----+-----+-----+-----+-----+-----+-----+

Bit 6, the one at issue, was occasionally used for the "minimize cost"
TOS. It never gained much OS support at the time, and Netfilter offers
better support for that ToS than the OSs of the pre-DiffServ era. 
Monitoring for that ToS bit by backbone ISP during the IETF discussions
about ECN didn't show any use. Ironically Netfilter could alter that
situation :-)

> If so, then the TOS target is dangerous since it will disrupt the 
> operation of ECN, and the documentation should mention that. I'd be happy 
> to write a patch to update it if people are interested.

Best if Netfilter makes it clear that Bit 6 is discouraged. Also the
description

# iptables --match tos --help
[!] --tos value                 Match Type of Service field from one of the
                                following numeric or descriptive values:
                                     Minimize-Delay 16 (0x10)
                                     Maximize-Throughput 8 (0x08)
                                     Maximize-Reliability 4 (0x04)
                                     Minimize-Cost 2 (0x02)
                                     Normal-Service 0 (0x00)
 
is misleading. Unlike DSCP there are no values for the ToS field as the
ToS field isn't a variable but a group of independent bits, of which
only one can be set at a time (of course there's an internal value, but
you shouldn't be leaking that as it gets confusing. For example lots of
software (including other parts of the kernel like setsockopt(IP_TOS))
use the value of the Precedence/TOS/MBZ octet and mask out the
irrelevant bits).

It would help immensely if the tos page noted that ToS is deprecated and
if ToS-backward-compatibility were added to DSCP.

# iptables --match dscp --dscp tos-minimize-delay

Obviously there would be no tos-minimize-cost, but that would be no
loss.

-- 
Glen Turner         Tel: (08) 8303 3936 or +61 8 8303 3936 
Network Engineer          Email: glen.turner@aarnet.edu.au
Australian Academic & Research Network   www.aarnet.edu.au
