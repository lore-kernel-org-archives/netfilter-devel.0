From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 0/2] fixes helper assingments (Was: Re: nf_nat tree updated)
Date: Fri, 24 Nov 2006 02:16:47 +0900 (JST)
Message-ID: <200611231716.kANHGnUo014460@toshiba.co.jp>
References: <4565C47E.3030907@trash.net>
	<200611231624.kANGOZDi010447@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net, kadlec@blackhole.kfki.hu, pablo@netfilter.org
In-Reply-To: <200611231624.kANGOZDi010447@toshiba.co.jp>
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


> Sorry for long silence, but please wait a minites.
> 
> I've found that helper asignment problem was because my check was poor
> to dc808fe28...
> 
> I'm writing a patch to fix them (to revert some change in that commits)
> for current linus tree.
> 
> At least, I think we should use nf_ct_helper_find_get() in
> nf_conntrack_netlink.c.

The commit(dc808fe28db59fadf4ec32d53f62477fa28f3be8)
	- removed the codes to assign helper to newly created conntrack via
	  nfctnetlink.

	- re-use the pointer to found helper to assign it to conntrack out
          of lock.

These patches revert their changes for 2.6.19 tree.

-- Yasuyuki Kozakai
