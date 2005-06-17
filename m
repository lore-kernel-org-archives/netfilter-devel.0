From: Joakim Axelsson <gozem@gozem.se>
Subject: GFP_KERNEL i checkentry
Date: Fri, 17 Jun 2005 18:50:26 +0200
Message-ID: <20050617165026.GY12820@aaricia.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I have during my developing of some new modules be running into some
problem which I need help with. Since im running my routers on old
2.4.23-kernel i have been developing for it. However i will most probably
convert to 2.6 soon.

Anyway, in "ipt_checkentry" that is executed everytime a new rule is added
which uses the module (or acutally whenever ANY rule is changed, added or
removed) it would seem that the kernel (atleast 2.4) considers this to be
inside an interupt-handler. I guess this is the softinterupt syscall that
get/setsockopt() refers to. However, i was using GFP_KERNEL to allocate
memory here. This seems to be wrong and needs to be GTP_ATOMIC. In _very_
rare occations this will trigger the BUG() on line 1130 in mm/slab.c (in
kernel 2.4.23) whenever the general fiting slabs needs to be grown.

Now to the problem. As far as i can see, vanilla 2.6.11.9 has this problem
in ipt_SAME. Possbile ipt_connlimit and ipt_recent. However i don't think
proc fs punctions need to be GFP_ATOMIC. Possbily this problem exists in other
modules in patch-o-magic. I havn't had a time to check it. However, among
those patches i use from an about 1 year old pom in my 2.4.23 routing kernel
there are several occations of this.

Again, this is a very very rare bug to trigger. I had to load ALOT of
instances using iptables-restore of my module before the bug was triggered.

Question is: Should it really be GFP_ATOMIC in all of the modules hook
functions? 

Statement: Patch-o-magic possibly has alot of bugs with this that needs to
be checked.

-- 
/Joakim Axelsson A.K.A Gozem@EFnet
