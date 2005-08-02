From: Daniel Drake <dsd@gentoo.org>
Subject: "ip_local_deliver: bad skb" messages
Date: Tue, 02 Aug 2005 17:18:20 +0100
Message-ID: <42EF9CCC.5090609@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Ralf.Hildebrandt@charite.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
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

Hi Patrick,

According to the user in http://lkml.org/lkml/2005/7/18/27 the patch that you 
reverted in light of a bug we discussed previously seems to have resulted in 
some odd messages appearing in the logs, e.g.:

Aug  1 07:05:57 moriah PROTO=17 127.0.0.1:34977 127.0.0.1:53 L=63 S=0x00 I=41527
F=0x4000 T=64
Aug  1 07:05:57 moriah ip_local_deliver: bad skb: PRE_ROUTING LOCAL_IN LOCAL_OUT
POST_ROUTING
Aug  1 07:05:57 moriah skb: pf=2 (unowned) dev=lo len=181

This was reported at Gentoo's bugzilla (http://bugs.gentoo.org/100944), and 
the good news is that it appears to be fixed in 2.6.13-rc4.

I was wondering if you might be able to point me at the patch which solved 
this issue, so that we can fix Gentoo's 2.6.12 and maybe also consider for 
inclusion in linux-stable?

Thanks,
Daniel
