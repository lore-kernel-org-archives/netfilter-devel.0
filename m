From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: RE: RPC patch creates kernel panic
Date: Fri, 02 Apr 2004 10:14:04 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404020014.i320E5l10952@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Daniel Chemko" <dchemko@smgtec.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Thanks Daniel - I think this is good .. skimming through it I *think* the 
protocol tower section near the bottom has what I will need ... but
a bit of reading will tell for sure (I'm looking for the on-the-wire
packet structure).

http://www.opengroup.org/onlinepubs/9629399/apdxl.htm#tagcjh_32



----- Original Message -----
>From: "Daniel Chemko" <dchemko@smgtec.com>
>To: "Ian Latter" <Ian.Latter@mq.edu.au>, "John A. Sullivan III" 
<john.sullivan@nexusmgmt.com>
>Subject:  RE: RPC patch creates kernel panic
>Date: Thu, 01 Apr 2004 14:34:56 -0800
>
> Ian Latter wrote:
> > Hello John,
> > 
> > 
> >   Thank you for this report.
> > 
> >   The RPC conntrack helper was written to support ONC RPC -
> > typically used on Unix hosts - where as Windows uses DCE RPC.
> > When I last looked at that module, I tried to find technical
> > information on the differences of the two, and was unable to
> > find any - but had the impression from what I could find that the
> > two weren't compatible.
> > 
> >   Whether or not the module recieves valid/invalid traffic, it
> > shouldn't crash - and I want to fix that. 
> > 
> >   However, if you have access to documentation on DCE RPC
> > protocol/standards then please forward that/them through, as any
> > such documentation would be useful for broadening support.
> 
> How's this?
> http://www.opengroup.org/onlinepubs/9629399/toc.htm
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
