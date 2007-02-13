From: shah hemal <hshah127@yahoo.com>
Subject: okfn function
Date: Tue, 13 Feb 2007 02:42:54 -0800 (PST)
Message-ID: <20070213104254.18913.qmail@web36506.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

          I am using NF_IP_FORWARD Hook for forwarding
the packets. In meantime, i am caching the packets to 
local buffer. For the same, i have register the
netfilter hook and wrote my own handler function.

Now i want to know how to use  okfn agrument function.

Can i use it forward the packets which i have cached.

thanks in advance.

hemal.
