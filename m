From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: taking related connections to the limit
Date: Thu, 4 Mar 2004 23:38:16 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403042331070.30943-100000@filer.marasystems.com>
References: <20040304120402.GH14383@magicbluesmoke.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John P. Looney" <valen@tuatha.org>
In-Reply-To: <20040304120402.GH14383@magicbluesmoke.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 4 Mar 2004, John P. Looney wrote:

> If a packet has dest ip X, dport 110, do a DNAT --to IP Y, record the SRC IP
> If a subsequent packet comes into dest IP X, from that SRC IP, --dport 25 from the same IP, DNAT --to IP Y also.

You should be able to do something like this with the help of the set
extension to remember SRC IP for a while. You will need the help of a
little userspace program to time out sessions after a while, but not much
more.

Regards
Henrik
