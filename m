From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Sample POM adding packet value field?
Date: Wed, 30 Jun 2004 19:00:54 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406301859020.12023-100000@filer.marasystems.com>
References: <20040630152903.40734.qmail@web13907.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040630152903.40734.qmail@web13907.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jun 2004, Scott MacKay wrote:

> Are there any POM additions which would add a data
> field to packets, much like how MARK does?

No, there simply is no fields available in the skbuff for this..

What there is is CONNMARK which adds per-connection mark attributes within 
netfilter.

There is also a proposed patch to allow for selective bit mask operations 
on the nfmark (MARK).

Regards
Henrik
