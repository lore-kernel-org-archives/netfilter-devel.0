From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 12/12]: Convert conntrack/ipt_REJECT to new
 checksumming functions
Date: Thu, 06 Apr 2006 14:19:45 -0700 (PDT)
Message-ID: <20060406.141945.06115674.davem@davemloft.net>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
	<20060406100509.17409.82693.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060406100509.17409.82693.sendpatchset@localhost.localdomain>
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
Date: Thu,  6 Apr 2006 12:05:09 +0200 (MEST)

> [NETFILTER]: Convert conntrack/ipt_REJECT to new checksumming functions
> 
> Besides removing lots of duplicate code, all converted users benefit
> from improved HW checksum error handling. Tested with and without
> HW checksums in almost all combinations.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Also applied, thanks a lot Patrick.
