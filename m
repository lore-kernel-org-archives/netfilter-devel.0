From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] Add mark to packet from libipq
Date: Thu, 16 Oct 2003 09:31:06 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310160925400.6046-100000@filer.marasystems.com>
References: <1066289019.20545.30.camel@porky>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, <nufw-devel@nongnu.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eric Leblond <eric@regit.org>
In-Reply-To: <1066289019.20545.30.camel@porky>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 16 Oct 2003, Eric Leblond wrote:

> > but in reality this is not needed either as the userspace knows the
> > original mask and can a apply whatever transformations it likes 
> > when giving the new verdict mask.
> 
> How could userspace knows it ?

It got the mark with the packet in packet_msg->mark, so the userspace
application can just apply the transformation it likes when setting the
verdict.

Example using mask operation

   mark = newvalue | (packet_msg->mark & mask);

but obviously other transformations is possible as well.

Regards
Henrik
