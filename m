From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [PATCH] ctnetlink: Fix dumping of helper name.
Date: Tue, 27 Dec 2005 14:46:21 +0100
Message-ID: <43B145AD.4040108@eurodev.net>
References: <43B1434C.8000005@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <43B1434C.8000005@ingate.com>
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

Marcus Sundberg wrote:
> this patch fixes ctnetlink dumping of the helper name.

It looks fine. Thanks Marcus.

@Patrick: JFYI, this bug doesn't affect nf_conntrack_netlink, so we
don't need a patch for it.

-- 
Pablo
