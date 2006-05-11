From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] [PATCH] clean up nf_log API
Date: Thu, 11 May 2006 10:44:10 +0200
Message-ID: <4462F95A.7060305@trash.net>
References: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
	<4462CD64.1060507@net.in.tum.de>
	<20060511083925.GD10324@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Gregor Maier <gregor@net.in.tum.de>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060511083925.GD10324@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> I now actually like the idea that the old LOG target and old ULOG target
> just continue to do what the used to do. 


I fully agree. I already changed the default behaviour back to just use
their own logging functions, nf_log backends can be used by specifying
an extra flag. This isn't supported by userspace so far, so we are free
to rip it out again.
