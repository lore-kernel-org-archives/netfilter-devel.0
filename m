From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 22:20:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F944376.6040903@trash.net>
References: <Pine.LNX.4.44.0310201133040.23768-100000@filer.marasystems.com> <3F942CB6.5060005@trash.net> <20031020183741.GB20288@sunbeam.de.gnumonks.org> <20031020194147.GA11786@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 Henrik Nordstrom <hno@marasystems.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20031020194147.GA11786@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Balazs,

Balazs Scheidler wrote:

>Sorry to jump into the conversation, it just occurred something I've read
>about relayfs:
>

Suggestions are always welcome.

>quoting from the announcement:
>
>"relayfs is a filesystem designed to provide an efficient mechanism for
>tools and facilities to relay large amounts of data from kernel space
>to user space.  Full details can be found in Documentation/filesystems/
>relayfs.txt.  The current version can always be found at
>http://www.opersys.com/relayfs."
>
>This _might_ be of interest when complete tables are to be dumped, though
>the ctnetlink based interface is better when the userspace app provides more
>specific queries.
>

I believe we should stick to a single consistent interface for user comfort.

Best regards,
Patrick
