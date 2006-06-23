From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: concerning p-o-m fixes for 2.6.17 API change
Date: Fri, 23 Jun 2006 22:58:31 +0200
Message-ID: <1151096311.3421.10.camel@murdegern.hindenburgdamm.example>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi list,

I noticed the match/target API changed a bit in 2.6.17,
so a bunch of code in patch-o-matic-ng needs updates.
I fixed ipp2p, ROUTE, time, and u32 (it's quite trivial).

I'd like to submit the patches (and thus work against the
"bit-rot" we all hate). Problem is, they are quite clumsy -
the correct way IMHO is to copy the latest kernel directory
(normally linux-2.6/) to linux-2.6.17 and then fix that,
so 2.6.16 and older kernels still work, too. So you can't
see what is happening in the patches, they just create 99%
identical copies of the old files.

Patrick, I guess you're the one to ask - would you like
those patches, and in what format?

Regards,
Torsten
