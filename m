From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: libipq: a way to use various programs?
Date: Sat, 23 Oct 2004 02:22:49 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0410230222160.15235@filer.marasystems.com>
References: <20041022174152.1424501d.tigrezno@log01.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jvalencia <tigrezno@log01.org>
In-Reply-To: <20041022174152.1424501d.tigrezno@log01.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 22 Oct 2004, Jvalencia wrote:

> Hi again, i'm trying to use 2 libipq programs to handle packets, but it looks like only one catching them.
> Is there any way to allow more than one program handle packets, like a chain?

You then need to pass the packet data among your programs in userspace.

ip_queue only supports a single "client" at a time.

Regards
Henrik
