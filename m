From: Jon Masters <jonathan@jonmasters.org>
Subject: SUMMARY: KVM+nf_conntrack_htable_size
Date: Sun, 31 Jan 2010 04:10:33 -0500
Message-ID: <1264929033.7499.22.camel@tonnant>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dallas.jonmasters.org ([72.29.103.172]:50145 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0AaJKp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Jan 2010 04:10:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Folks,

Thanks to everyone who helped me poke a little at the netfilter code.
Since I'm not usually a network guy and haven't really kept up with
things like the namespace code, this was fun. I have some results.

The problem (as Eric hinted) is that we have a global
nf_conntrack_htable_size, which is manipulated every time we create a
new hashtable. This used to happen only once, but now that we have
multiple network namespaces, it will happen every time we create a new
namespace due to the code registering with register_pernet_subsys. At
this time, the value of the hashtable may be changed underneath code
that is currently using it for another hashtable instance. Additionally,
the "resize" code (via module parameter or via sysctl) only changes the
root netns hashtable, then changes this value, also busticating stuff.
Finally, the very fact that this variable is exported directly is
*asking* for trouble and random corruption to happen later on.

So, there are a great many issues with how the conntrack hashtables are
managed (looks literally as it it used to be fine then namespace code
came along and broke assumptions that had been there since the start),
and they should not be considered safe for use with multiple namespaces
in my opinion. The solution would seem to be to remove this as a global
and make it per namespace, or even per hashtable (there is usually a 1:1
mapping, but the expect code uses this variable too).

Can someone give me some advice on which solution you prefer of these?
Or if you have an alternative preference. I think for now I'll hack up
something involving per-namespace hashtable sizes.

Jon.


