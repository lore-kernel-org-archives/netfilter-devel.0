From: Patrick McHardy <kaber@trash.net>
Subject: Re: is skb payload missing when using NF_IP_POST_ROUTING ?
Date: Mon, 17 Sep 2007 15:43:33 +0200
Message-ID: <46EE8485.7080107@trash.net>
References: <904365.95538.qm@web28107.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: SEBASTIEN LEGER <sebastienleger@yahoo.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Received: from stinky.trash.net ([213.144.137.162]:41003 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbXIQNto (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:49:44 -0400
In-Reply-To: <904365.95538.qm@web28107.mail.ukl.yahoo.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

SEBASTIEN LEGER wrote:
> Hi,
> 
> I'm trying to develop a queue handler using netfilter and
> iptables mangling to catch all data coming in and out of my network
> card. I'm using a hook on NF_IP_PRE_ROUTING and another one on
> NF_IP_POST_ROUTING. Everything is running fine but...
> 
> unfortunately,
> all skb received on NF_IP_POST_ROUTING hook seem to have a non
> initialized random payload, however packet length is correct (size is
> retrieved from IP header analysis, not from skb length field). Packet
> payload is dumped on dmesg and compared to a live tcpdump capture
> running in background: dmesg contains junk data above TCP layer instead
> of pure FTP :(((
> 
> Does it mean that skb payload is not yet
> available when NF_IP_POST_ROUTING hooks are called? my understanding
> was that post routing was called just before sending packet on the
> network device, is it wrong? if I misunderstood, how can I catch
> packets coming out of my device and access to their full content?


Most likely you're not handling non-linear skbs properly.
Look into nfnetlink_queue for an example.
