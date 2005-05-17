From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] fix ipt_ACCOUNT for 32bit netmasks
Date: Tue, 17 May 2005 21:48:21 +0200
Message-ID: <428A4A85.3010605@trash.net>
References: <200505131308.09535.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
In-Reply-To: <200505131308.09535.thomas.jarosch@intra2net.com>
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

Thomas Jarosch wrote:
> Hi,
> 
> attached is a patch to fix ipt_ACCOUNT for /32 netmasks.
> While looking through the code I also found and fixed a locking bug.
> 
> Please apply the patch or let me know if there's trouble applying.

Applied, but I suggest to replace that code by ffz(~netmask).

Regards
Patrick
