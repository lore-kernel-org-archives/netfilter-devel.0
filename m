From: Steve Davies <davies147@gmail.com>
Subject: SIP/RTP support coming?
Date: Sat, 12 Feb 2005 11:52:45 +0000
Message-ID: <5caa9b8705021203527b3891d@mail.gmail.com>
Reply-To: Steve Davies <davies147@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

>From the FAQ on the netfilter site, I see the comment:

"The netfilter/iptables team has currently no resources to implement
SIP conntrack/NAT support, but we're always open for sponsors :)"

I have also noticed that Linksys have implemented some basic support
for SIP/SDP/RTP conntrack/NAT. I believe that due to the complexity of
the SIP protocol, there are one or two small problems with certain
message types - mentioned in
https://lists.netfilter.org/pipermail/netfilter/2004-December/057518.html
(A patch taken from the linksys code was offered in
https://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018252.html)

Are there plans to integrate this officially? Should I take time to
(try to) update the patch to the 2.6.x kernel? Am I missing something?

Thanks,
Steve
