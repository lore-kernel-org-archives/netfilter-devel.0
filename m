From: Patrick McHardy <kaber@trash.net>
Subject: Re: ulogd2 and nflog prefix
Date: Mon, 15 May 2006 09:06:49 +0200
Message-ID: <44682889.107@trash.net>
References: <4467EC50.3030907@snapgear.com> <44681346.3000301@trash.net>
	<446826EF.1070004@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <446826EF.1070004@snapgear.com>
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

Philip Craig wrote:
> On 05/15/2006 03:36 PM, Patrick McHardy wrote:
> 
>>Most other netlink users in the kernel dealing with strings use
>>rtattr_strlcpy these days, which automatically terminates strings.
>>I think we should do the same for consistency.
> 
> 
> rtattr_strlcpy seems to be for getting the string out of a message,
> not for creating a message.  It copies the string and adds a null
> terminator.  The terminator in the message is optional.


Right, I somehow though the prefix was also configured using netlink,
which is of course wrong. In that case I think nfnetlink_log should
just 0-terminate the string. BTW, Is there any reason why the prefix
is truncated to NFULNL_PREFIXLEN?
