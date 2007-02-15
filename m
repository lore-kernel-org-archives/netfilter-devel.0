From: Sebastien Tricaud <sebastien.tricaud@wengo.com>
Subject: Re: Change Packet Payload
Date: Thu, 15 Feb 2007 15:45:40 +0100
Message-ID: <45D47214.8000508@wengo.com>
References: <1171012218.4162.27.camel@LinuxCampo>	<1171013512.18531.5.camel@localhost>	<45D23748.2090609@netfilter.org>	<45D2DA9E.4010005@wengo.com>	<45D2DBFB.7040702@trash.net>	<45D2DCA9.1050100@wengo.com>	<45D2DEDA.7020204@wengo.com>
	<45D2DFE8.8080301@trash.net> <45D3AB00.7080505@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45D3AB00.7080505@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,


I can't find any information for licensing issues for Stevens material.
However for IETF stuff, reading RFC 3978 section 3.3 seems pretty clear.

In short :

"the Contributor, and each named co-Contributor, and the organization he
or she represents or is sponsored by (if any) grant a perpetual,
irrevocable, non-exclusive, royalty-free, world-wide right and license
to the ISOC and the IETF under all intellectual property rights in the
Contribution:"

"to extract, copy, publish, display, distribute, modify and incorporate
into other works, for any purpose (and not limited to use within the
IETF Standards Process) any executable code or code fragments that are
included in any IETF Document (such as MIB and PIB modules)"


Then there is a follow up to section 5 which states that taking code or
quotes requires the following :
"Copyright (C) The Internet Society <year>. This version of this MIB
module is part of RFC XXXX; see the RFC itself for full legal notices."


As for checksum computation. I think it is bad to have shared code in
several libraries. How about putting everything in nfnetlink ? I that
appropriated ?



Thanks,
Sebastien.


Pablo Neira Ayuso wrote:
>
> The code seems very similar to the one that is available in RFC1071. I
> recently added initial support for message checksumming to conntrackd
> and used that code (slightely modified) indicating the source, thus not
> explicitely licensing that part as GPL since I don't own the copyright
> of it. Can we consider examples available in a RFC as public domain code?
>
>   
