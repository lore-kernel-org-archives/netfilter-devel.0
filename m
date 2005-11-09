From: Pablo Neira <pablo@netfilter.org>
Subject: Re: [PATCH 4/8] Fix racy counters zeroing
Date: Wed, 09 Nov 2005 02:31:50 +0100
Message-ID: <43715186.2090502@netfilter.org>
References: <43700301.1060401@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <43700301.1060401@netfilter.org>
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

Pablo Neira wrote:
> Fix racy zero counters operation at getting.

Now I understand. You dropped my patch to zero counters at getting[1]
since it is racy, but it seems that it slipped through the patch that
changes the allocation flag.

Since this patch applies to your git tree, I just tried to fix what was
in your tree.

[1] See [PATCH 6/7] add support for zeroing counters at getting

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
