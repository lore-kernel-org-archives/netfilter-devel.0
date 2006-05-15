From: Philip Craig <philipc@snapgear.com>
Subject: ulogd2 and nflog prefix
Date: Mon, 15 May 2006 12:49:52 +1000
Message-ID: <4467EC50.3030907@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

The log message prefix contained in the netlink message is
not null terminated, but nflog_get_prefix() returns a pointer
to the data in the netlink message, and ulogd2 treats it as
null terminated.

I can create a patch to fix this if I know how it is meant to work:
- null terminate in kernel?
- nflog_get_prefix() should copy and null terminate?
- add nflog_get_prefix_len() and handle in ulogd?
