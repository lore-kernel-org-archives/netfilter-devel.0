From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: Cannot delete hashlimit match entries
Date: Fri, 04 Feb 2005 19:33:04 -0500
Message-ID: <42041440.1050405@cookinglinux.org>
References: <20050204232444.GB30789@linuxace.com>
Reply-To: sjean@cookinglinux.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050204232444.GB30789@linuxace.com>
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

Phil Oester wrote:
> As noted by a bugzilla reporter, 
> 
> iptables -A foo -m hashlimit --hashlimit 5/s --hashlimit-mode srcip --hashlimit-name foo
> iptables -D foo -m hashlimit --hashlimit 5/s --hashlimit-mode srcip --hashlimit-name foo
> iptables: Bad rule (does a matching rule exist in that chain?)
> 
> In reviewing this, I think the fact that *hinfo is initialized by the kernel
> will make this a tough problem to fix.  The unitialized match is:
> 

Yes. The only way am aware of to fix it is sizing the matching part with offsetof().
Fortunately, in this case, all modified member are at end so we can use this hack without
breaking any compatibility.

> Ideas?

Index: extensions/libipt_hashlimit.c
===================================================================
--- extensions/libipt_hashlimit.c       (revision 3525)
+++ extensions/libipt_hashlimit.c       (working copy)
@@ -351,8 +351,7 @@
         .name           = "hashlimit",
         .version        = IPTABLES_VERSION,
         .size           = IPT_ALIGN(sizeof(struct ipt_hashlimit_info)),
-       .userspacesize  = IPT_ALIGN(sizeof(struct ipt_hashlimit_info)),
-       //offsetof(struct ipt_hashlimit_info, prev),
+       .userspacesize  = offsetof(struct ipt_hashlimit_info, hinfo),
         .help           = &help,
         .init           = &init,
         .parse          = &parse,

By now, SVN is crush. 8( I can't tell wheter this patch applies or not. but at least, you got the idea.


> 
> Phil
> 

Cheers,
Samuel
