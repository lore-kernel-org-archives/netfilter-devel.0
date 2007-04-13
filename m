From: Patrick McHardy <kaber@trash.net>
Subject: Re: Locking in iptables target functions
Date: Fri, 13 Apr 2007 04:46:11 +0200
Message-ID: <461EEEF3.5090704@trash.net>
References: <461E7D0C.8010408@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <461E7D0C.8010408@cpsc.ucalgary.ca>
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

Rennie deGraaf wrote:
> Are interrupts disabled while iptables match and target functions are
> being evaluated?

No.

>  If so, then is there an efficient method to test this?
>  If not, they why does the kernel complain when I attempt to acquire a
> spinlock from within a target function?

Impossible to tell without seeing the error.
