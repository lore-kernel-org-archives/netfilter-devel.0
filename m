From: Philip Craig <philipc@snapgear.com>
Subject: Re: Suggestion regarding masquerading / action when the link goes
 down
Date: Fri, 20 Jun 2003 10:35:44 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EF256E0.3090707@snapgear.com>
References: <005001c32c4d$6e2c3240$7b00a8c0@chr> <20030619121154.GI20125@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christian Morgenstern <C.Morgenstern@gmx.de>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030619121154.GI20125@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Fri, Jun 06, 2003 at 07:02:35PM +0200, Christian Morgenstern wrote:
>>Would it be possible to have an additional option for the kernel config, so
>>the connections aren't cleared if the connection goes down ?
> 
> 
> Kernel config option seems to be a bit static, and too 'big'.  What
> about a sysctl?  I'm happy to accept a patch that makes this behaviour
> sysctl-controllable.

Shouldn't this be a new option for the MASQUERADE target, so that it
can be set per rule rather than as a global setting for all rules?

Alternatively, you could change the SNAT target so that it doesn't
require an address to be specified.

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances
