From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: netfilter
Date: Thu, 27 May 2004 12:48:31 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405271247330.11108-100000@filer.marasystems.com>
References: <20040526021817.16087.qmail@web13903.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: sokhan heng <sokhan2001@yahoo.com>
In-Reply-To: <20040526021817.16087.qmail@web13903.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 25 May 2004, sokhan heng wrote:

> I wonder if I could ask you one question please about
> netfilter? I wonder if it can be used to prioritise
> traffic, by that I mean when two packets are sent to
> the same destination, one can be delayed to let the
> other packet pass first. if it can, can you tell me
> what topic should I look for to get how to do that
> please?

This is not the job of netfilter, but is instead done by the 
shaping/queueing components in the Linux kernel. See the tc command and 
related documentation.

Regards
Henrik
