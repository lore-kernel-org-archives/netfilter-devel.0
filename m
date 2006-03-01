From: Thomas Gelf <thomas@gelf.net>
Subject: NAT behave - hairpinning
Date: Wed, 01 Mar 2006 13:42:13 +0100
Message-ID: <du44qi$5gt$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all,

I googled around for a some time to find information regarding "hairpin"
support for netfilter.

Reason: I don't like my public SIP Registrar / Proxy to redirect calls
between my local STUN-enabled and NATed SIP clients to an external RTP
Proxy (no, sip-conntrack-nat is not what I'm looking for).

The most recent hint relating this topic I've managed to find on Rusty's
bleeding edge page: http://ozlabs.org/~rusty/index.cgi/2005#2005-10-10

It would be great if someone could give me some additional information:
- is hairpinning meant to be supported in near-future official linux
   kernels?
- is it planned to provide such a patch on patch-o-matic?

Thanks a lot!

Kind regards,
Thomas Gelf


-- 
Thomas Gelf <thomas@gelf.net>
