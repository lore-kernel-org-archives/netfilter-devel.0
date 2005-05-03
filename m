From: BJ Premore <bj-netfilter@renesys.com>
Subject: changing packet length?
Date: Tue, 3 May 2005 17:34:06 -0400
Message-ID: <20050503213406.GE13894@tigris.renesys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi everyone.  I've been pulling my hair out lately, using
netfilter/ipq to try to add options to the TCP header of an
outgoing packet.  However, even just adding 4 bytes of no-op
options results in subsequent incoming packets (via
ipq_get_packet) looking mangled.  (After adding the options,
all appropriate fields were updated--checksums, length
fields, etc.  Also, I was extremely carefully to follow the
specifications for adding the TCP options, proper padding,
etc., etc.  I'm pretty sure my problems do not have to do
with the formatting of the packet.)

So my hopefully simple question is, can packet sizes be
changed and then reinjected using ipq_set_verdict?  I found
one reference that seemed to suggest that modified packets
had to stay the same size.  I've tested modifying packets
without changing their overall byte sizes, and that does in
fact seem to work (Eg, I changed the TTL field.).

If the answer to the above question is 'yes', then I'll
provide more details in the follow-up, in hopes of getting
to the bottom of my troubles.

Thanks in advance,

-bj

BJ Premore
