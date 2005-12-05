From: Philip Craig <philipc@snapgear.com>
Subject: Re: TCPMSS is not restricted to mangle table
Date: Mon, 05 Dec 2005 11:33:03 +1000
Message-ID: <439398CF.2020802@snapgear.com>
References: <4393895D.1020106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4393895D.1020106@trash.net>
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

On 12/05/2005 10:27 AM, Patrick McHardy wrote:
> I just noticed the TCPMSS target is not restricted to the
> mangle table. Any opinions about whether we should change
> this, perhaps with a warning period?

The historical reason for this is that originally the mangle table
only had PREROUTING and OUTPUT hooks, and so you couldn't clamp
forwarded packets in the mangle table (since it needs the outgoing
interface).

The majority of existing scripts and documentation still reference
the filter table.  So changing this will affect most of its users.

So I think update the official documentation for consistency, but
leave the code how it is.
