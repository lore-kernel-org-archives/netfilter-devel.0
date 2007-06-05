From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 02/03]: ip_tables: fix compat related crash
Date: Tue, 05 Jun 2007 12:56:21 -0700 (PDT)
Message-ID: <20070605.125621.09952042.davem@davemloft.net>
References: <20070605133508.10309.36756.sendpatchset@localhost.localdomain>
	<20070605133511.10309.33387.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070605133511.10309.33387.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Tue,  5 Jun 2007 15:35:11 +0200 (MEST)

> [NETFILTER]: ip_tables: fix compat related crash
> 
> check_compat_entry_size_and_hooks iterates over the matches and calls
> compat_check_calc_match, which loads the match and calculates the
> compat offsets, but unlike the non-compat version, doesn't call
> ->checkentry yet. On error however it calls cleanup_matches, which in
> turn calls ->destroy, which can result in crashes if the destroy
> function (validly) expects to only get called after the checkentry
> function.
> 
> Add a compat_release_match function that only drops the module reference
> on error and rename compat_check_calc_match to compat_find_calc_match to
> reflect the fact that it doesn't call the checkentry function.
> 
> Reported by Jan Engelhardt <jengelh@linux01.gwdg.de>
> 
> Signed-off-by: Dmitry Mishin <dim@openvz.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
