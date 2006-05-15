From: Patrick McHardy <kaber@trash.net>
Subject: Re: ulogd2 and nflog prefix
Date: Mon, 15 May 2006 07:36:06 +0200
Message-ID: <44681346.3000301@trash.net>
References: <4467EC50.3030907@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <4467EC50.3030907@snapgear.com>
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
> The log message prefix contained in the netlink message is
> not null terminated, but nflog_get_prefix() returns a pointer
> to the data in the netlink message, and ulogd2 treats it as
> null terminated.
> 
> I can create a patch to fix this if I know how it is meant to work:
> - null terminate in kernel?
> - nflog_get_prefix() should copy and null terminate?
> - add nflog_get_prefix_len() and handle in ulogd?


Most other netlink users in the kernel dealing with strings use
rtattr_strlcpy these days, which automatically terminates strings.
I think we should do the same for consistency.
