From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Usage of CONNMARK
Date: Fri, 4 Feb 2005 15:17:35 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0502041515360.10050@filer.marasystems.com>
References: <42032EC5.4090303@multitech.co.in>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
To: Vinod Chandran <vinod_chandran@multitech.co.in>
In-Reply-To: <42032EC5.4090303@multitech.co.in>
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

On Fri, 4 Feb 2005, Vinod Chandran wrote:

> I am using the CONNMARK patch.
> Inside conntrack_core, in case of special conditions, I have modified the 
> mark value in the conntrack.

When in conntrack is this modification done?

> However this CONNMARK value is getting effective only for the next packet and 
> not for the same packet.

The connmark match looks at the connection mark value at the time the 
connmark match is evaluated.

> Is there some way by which, I can make the settings applicable to the same 
> packet itself?

It is, assuming it's done before you need to evaluate the match.

Regards
Henrik
