From: Glen Turner <glen.turner@aarnet.edu.au>
Subject: Re: TOS target broken wrt ECN (was RFC 1349)
Date: Tue, 04 May 2004 14:50:19 +0930
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1083648019.15357.4.camel@andromache>
References: <Pine.LNX.4.44.0404290113410.17188-100000@filer.marasystems.com>
	 <Pine.LNX.4.58.0404291748430.5102@chris.camcom.co.uk>
	 <1083317127.12783.71.camel@andromache>
	 <Pine.LNX.4.58.0404301055140.17235@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.58.0404301055140.17235@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2004-04-30 at 19:52, Chris Wilson wrote:

> > Obviously there would be no tos-minimize-cost, but that would be no
> > loss.
> 
> Except financially ;)

Um no.  No ISP offers least charge routing for that ToS.

If you are building a network you can easily offer a
least cost DSCP. For example, we offer a DSCP=8 "worst
effort" service for bulk file transfers. DSCP=8 maps
to IP Precedence=1, allowing for older OSs to participate.
And the default mappings from DSCP to link layer markings
like 802.1p and MPLS Exp work well.

Search Google for "Scavenger service".  The AARNet web
site has iptables rules and code changes for Apache and
some FTP servers.

-- 
Glen Turner         Tel: (08) 8303 3936 or +61 8 8303 3936 
Network Engineer          Email: glen.turner@aarnet.edu.au
Australian Academic & Research Network   www.aarnet.edu.au
