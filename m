From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack tree
Date: Sun, 20 Mar 2005 17:42:57 +0100
Message-ID: <423DA811.3090608@trash.net>
References: <423889E6.1000703@trash.net>	<200503161954.j2GJsIhi017839@toshiba.co.jp>	<42389136.3050900@trash.net>
	<200503170831.j2H8VgbY014017@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200503170831.j2H8VgbY014017@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Hi, Patrick,
> 
> OK, I agree introducing nf_ct_ops.
> 
> But in the current, it's not acceptable to introduce nf_conntrack_common
> as you said in other mail. I think it needs many changes to ip_conntrack and
> ip_nat, it may be difficult to change nf_conn structure
> (e.g. optimization), and it will confuse us - What we unify is ?

We're unifying things common to ip_conntrack and nf_conntrack, like
mark, status, ... in order to keep the number of accessor functions
in nf_ct_ops to a minimum.

> My suggestion is pulling out common definitions of enum and flags to some
> common header files, and making {ip,nf}_conntrack*.h include them.
> No change to ip_conntrack_*.c is necessary.

Yes, that is one part. But some matches/targets need to get some
information from the conntrack. I've made a list of what is needed, so
we can talk in more concrete terms:

ipt_state:
- recognize untracked

ipt_helper:
- ct->master->helper->name

ipt_conntrack:
- recognize untracked
- tuples
- status
- expires

ipt_connmark/IPT_CONNMARK:
- mark

Creating a struct nf_conntrack_common should be ok for untracked,
status, expires, mark and master->helper->name. The tuples can't be
handled this way, for them we need nf_ct_ops.

Regards
Patrick
