From: James Morris <jmorris@namei.org>
Subject: Re: Panic in ipt_do_table with 2.6.16.13-xen
Date: Mon, 15 May 2006 23:31:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0605152331140.10964@d.namei>
References: <4468BE70.7030802@tektonic.net> <4468D613.20309@trash.net>
 <44691669.4080903@tektonic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751100AbWEPDcE@vger.kernel.org>
To: Matt Ayres <matta@tektonic.net>
In-Reply-To: <44691669.4080903@tektonic.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 15 May 2006, Matt Ayres wrote:

> I had initially sent my traces to the Xen guys.  They have not stated it is
> NOT specific to Xen, just that's it's unlikely.  I did not experience the
> problem with kernel 2.6.12, just with 2.6.16 (up to .13 bugfix release).  I
> have completely disabled all support for SCTP (protocol/netfilter/conntrack)
> as I know it is still quite buggy.  I know Xen touches the network code a lot,
> but nothing specific to iptables.  I had contacted them twice before LKML as I
> didn't want to post patch specific problems here.  I have no other patches
> applied besides the Xen patch.
> 
> My ruleset is pretty bland.  2 rules in the raw table to tell the system to
> only track my forwarded ports, 2 rules in the nat table for forwarding
> (intercepting) 2 ports, and then in the FORWARD tables 2 rules per VM to just
> account traffic.

Can you try using a different NIC?


- James
-- 
James Morris
<jmorris@namei.org>
