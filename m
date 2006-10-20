From: Patrick McHardy <kaber@trash.net>
Subject: Re: nfqueue/ipq difference
Date: Fri, 20 Oct 2006 12:02:50 +0200
Message-ID: <45389ECA.4010504@trash.net>
References: <1318F807-9466-4960-9ABE-1350E9B81E6C@cadvium.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: robert <rbscott@cadvium.net>
In-Reply-To: <1318F807-9466-4960-9ABE-1350E9B81E6C@cadvium.net>
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

robert wrote:
> As I was migrating to NFQUEUE, I noticed a small difference.  If you 
> are polling on an IPQ filedescriptor, then the error bit is set if  the
> queue runs out of buffer space.  In NFQUEUE, the error bit is  never
> set, but after doing a read, there is an error.  This error bit  is
> relatively important and in most applications would want to handle  a
> read  since both IPQ and NFQUEUE will not queue any new packets  until
> the entire buffer is flushed.  (at least, this is the behavior  that I
> am seeing).
> 
> If anyone is interested, i could post two small test programs that 
> illustrate this behavior. (not sure if this would be considered a bug).

Please, I can not see any difference between ipq and nfnetlink_queue.
