From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCHv4 0/2] Find address type on the packet's interface
Date: Mon, 19 Nov 2007 17:06:18 +0100
Message-ID: <4741B47A.40106@trash.net>
References: <11954877483732-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36847 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbXKSQGk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 11:06:40 -0500
In-Reply-To: <11954877483732-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Laszlo Attila Toth wrote:
> Hi Patrick,
> 
> This extension of addrtype match lets the address type checking be
> limited to the incoming or outgoing interface of the packets depending
> on the current hook.
> 
> In the FORWARD chain only one check is allowed but the user can choose
> which one would like to specifiy.

Thanks for changing this.

> Because of this extension the match has a new revision. Rev 0 can be
> used by older tools and rev 1 is for the modified iptables match.
> 
> The iptables patch is for revision 1 only.
> 
> Both the kernel module and the iptables module moved to xtables,
> but the kernel module uses ipt_addrtype_info in revision 0.


I just read up on your and Jan's discussion, but you were too fast
for me :) I'm not sure whether this is really a good candidate
for x_tables. IPv4 and IPv6 addrtype have different meanings, the
IPv4 addrtype is based on routing, IPv6 solely on the address.
Especially things like "--addrtype local" won't work, which is
IMO the most useful feature. And since you don't actually add IPv6
support, I don't see any advantage in moving to x_tables. So I
think for now I'd prefer a change to the ipt_addrtype match.
