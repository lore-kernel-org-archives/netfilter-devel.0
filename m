From: "Jesse Peng" <tzuhsi.peng@msa.hinet.net>
Subject: Re: NAT behave - hairpinning
Date: Sat, 4 Mar 2006 12:02:44 +0800
Message-ID: <002701c63f40$81b38300$3478fea9@acer21ce70712f>
References: <du44qi$5gt$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="ISO-8859-15";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>, "Thomas Gelf" <thomas@gelf.net>
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

Dear Thomas
Here is the link to the patch which handles P2P(Peer-to-Peer)traffic with 
hole punch and hairpin concerned according to linux netfilter nat 
behave,Please reference.
Patch:
http://lists.netfilter.org/pipermail/netfilter-devel/2006-January/023084.html
Coding hint:
http://lists.netfilter.org/pipermail/netfilter-devel/2005-December/022584.html
Theory:
http://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017479.html

Your sincerely
Jesse


----- Original Message ----- 
From: "Thomas Gelf" <thomas@gelf.net>
To: <netfilter-devel@lists.netfilter.org>
Sent: Wednesday, March 01, 2006 8:42 PM
Subject: NAT behave - hairpinning


> Hi all,
>
> I googled around for a some time to find information regarding "hairpin"
> support for netfilter.
>
> Reason: I don't like my public SIP Registrar / Proxy to redirect calls
> between my local STUN-enabled and NATed SIP clients to an external RTP
> Proxy (no, sip-conntrack-nat is not what I'm looking for).
>
> The most recent hint relating this topic I've managed to find on Rusty's
> bleeding edge page: http://ozlabs.org/~rusty/index.cgi/2005#2005-10-10
>
> It would be great if someone could give me some additional information:
> - is hairpinning meant to be supported in near-future official linux
>   kernels?
> - is it planned to provide such a patch on patch-o-matic?
>
> Thanks a lot!
>
> Kind regards,
> Thomas Gelf
>
>
> -- 
> Thomas Gelf <thomas@gelf.net>
>
>
> 
