From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip_nat_tftp: Fix expectation NAT.
Date: Mon, 12 Dec 2005 08:11:31 +0100
Message-ID: <439D22A3.4090900@trash.net>
References: <43980FAA.6060608@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <43980FAA.6060608@ingate.com>
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
> this patch fixes the case where the port in an initial TFTP packet
> is SNATed. Previously the port was never DNATed back for the expected
> connection.

Took me some time to understand why this works for other helpers and
not this one, but finally applied :) Thanks.
