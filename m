From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH, RFC] possible use of freed skbuff in netfilter.c
Date: Tue, 29 Apr 2003 23:54:44 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030429.235444.26991098.davem@redhat.com>
References: <200304251957.18012.bdschuym@pandora.be>
	<20030429145129.GG684@naboo.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: bdschuym@pandora.be, rusty@rustcorp.com.au,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20030429145129.GG684@naboo.intranet.astaro.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Harald Welte <laforge@netfilter.org>
   Date: Tue, 29 Apr 2003 16:51:29 +0200

   I'm fine with this fix, please apply (if it isn't already).

Applied.  Should we be putting this fix into 2.4.x as well?
