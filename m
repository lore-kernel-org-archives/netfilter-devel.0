From: John Heffner <jheffner@psc.edu>
Subject: Re: What to do with malformed l4proto packets? (resend)
Date: Fri, 06 Apr 2007 15:32:21 -0400
Message-ID: <4616A045.7050207@psc.edu>
References: <46168530.9070604@psc.edu> <46169176.2000507@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46169176.2000507@trash.net>
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

Patrick McHardy wrote:
> The REJECT target verifies the checksum, so this shouldn't happen.
> Are you sure its the REJECT target thats sending the RST?

You're right, I missed that.

Commit: 6150bacfec95c7042678667561664efcf10d4508
Author: Patrick McHardy <kaber@trash.net> Tue, 21 Jun 2005 14:03:46 -0700

     [NETFILTER]: Check TCP checksum in ipt_REJECT

     Signed-off-by: Patrick McHardy <kaber@trash.net>
     Signed-off-by: David S. Miller <davem@davemloft.net>


I'm guessing RHEL hasn't backported this fix into their ancient kernel 
yet.  Sorry to waste your time.

Thanks,
   -John
