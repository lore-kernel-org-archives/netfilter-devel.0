From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: real time stateful filtering question
Date: Wed, 17 Mar 2004 21:03:47 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403172000290.11069-100000@filer.marasystems.com>
References: <NEBBJFIAIKIHKGJDONCDAENMCCAA.smith-peter@comcast.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@gnumonks.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: peter smith <smith-peter@comcast.net>
In-Reply-To: <NEBBJFIAIKIHKGJDONCDAENMCCAA.smith-peter@comcast.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Mar 2004, peter smith wrote:

> I am a passive tap, not a bump in the wire. So, as you said, apparently
> netfilter is not the tool for the job, as for my software, I need to
> guarantee that each packet is processed to completion (i.e. by my userland
> software) before *any* processing is performed on subsequent packets in the
> flow, or subsequent packets in related flows.

And for this you need process packets at "wire speed", not dropping any 
packets until you have finished processing the first..

If you are using an early filter then this filter can only be used to skip 
gaps of uninteresting packets. As soon as you hit a packet where related 
traffic may be involved you must start buffering packets until processing 
of the first has finished.

a packet socket (or the libpcap interface to it) seems most suitable for 
this.

Regards
Henrik
