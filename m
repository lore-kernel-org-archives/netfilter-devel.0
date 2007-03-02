From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.20: ipt_owner match and INPUT chain
Date: Fri, 02 Mar 2007 12:57:11 +0100
Message-ID: <45E81117.1060107@trash.net>
References: <200703020946.20765.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703020946.20765.thomas.jarosch@intra2net.com>
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
> Hello together,
> 
> the ipt_owner match of 2.6.20 is not allowed to be used in the INPUT chain. 
> 
> The .hooks entry looks like this:
> .hooks          = (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING)
> 
> Back in the days it was allowed to be used in the INPUT chain for TCP/UDP.
> I've searched the mailinglist archive but couldn't find anything useful.
> What's the reason behind the change?

The mainline kernel never supported this, you're thinking of the
owner socketlookup patch, which had multiple issues and was never
merged.
