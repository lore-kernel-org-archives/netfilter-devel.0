From: Martijn Lievaart <netfilter-devel@rtij.nl>
Subject: I don't understand what goes where, very confused about POM-ng
Date: Wed, 05 May 2004 19:14:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4099210C.40309@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Using CVS of today 5/5/2004.

I'm trying to port the psd match to 2.6. The C code is ready (not much 
of a change needed). However POM will not apply the headerfile from the 
linux/ tree, I need to copy it to the linux-2.6 tree. I would expect 
that everything in the linux tree would also be applied, eventually 
overridden by something in the linux-2.6 tree. Why else have seperate 
linux-2.4 trees?

By now I gather that POM-ng tries to find a best match, and does this 
independently for the ladds and the files (and the patches as well?). I 
find this very confusing, but I think this is by design?

Anyhow, I looked at a couple of other patches and many have their header 
file only in the linux-tree. Many are also base, so probably already 
applied to any 2.6 kernel, but the why have a linux-2.6 tree in that 
case? One patch where this really breaks is the XOR patch, it does not 
apply to 2.6 because POM-ng does not copy the header.

As an alternative, would it be possible to just create a linux-2.6.patch 
file that applies after the 2.4 patch has applied? This would be a good 
solution because many patches need only minor modifications to newly 
added files (especially only ipt_xxx.c) to make them run under 2.6.

TIA,
Martijn Lievaart
