From: Phil Oester <kernel@linuxace.com>
Subject: Cannot delete hashlimit match entries
Date: Fri, 4 Feb 2005 15:24:44 -0800
Message-ID: <20050204232444.GB30789@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

As noted by a bugzilla reporter, 

iptables -A foo -m hashlimit --hashlimit 5/s --hashlimit-mode srcip --hashlimit-name foo
iptables -D foo -m hashlimit --hashlimit 5/s --hashlimit-mode srcip --hashlimit-name foo
iptables: Bad rule (does a matching rule exist in that chain?)

In reviewing this, I think the fact that *hinfo is initialized by the kernel
will make this a tough problem to fix.  The unitialized match is:

(gdb) inspect *(struct ipt_hashlimit_info *)((struct ipt_entry_match)*a->elems)->data
$42 = {name = "foo\000\000\000\000\000\000\000\000\000", cfg = {mode = 6, avg = 2000, burst = 5, 
    size = 0, max = 0, gc_interval = 1000, expire = 10000}, hinfo = 0x0, u = {ptr = 0x0, 
    master = 0x0}}

while once initialized:

(gdb) inspect *(struct ipt_hashlimit_info *)((struct ipt_entry_match)*b->elems)->data
$43 = {name = "foo\000\000\000\000\000\000\000\000\000", cfg = {mode = 6, avg = 2000, burst = 5, 
    size = 0, max = 0, gc_interval = 1000, expire = 10000}, hinfo = 0xd4875000, u = {
    ptr = 0xd48733d0, master = 0xd48733d0}}

So...unless I'm missing something, they really don't match.  

Ideas?

Phil
