From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: libipq/payload doubt
Date: Thu, 20 May 2004 17:02:03 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405201659590.7143-100000@filer.marasystems.com>
References: <20040520133313.70860.qmail@web13905.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ulysses Almeida <munky@maluco.com.br>,
   Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040520133313.70860.qmail@web13905.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 May 2004, Scott MacKay wrote:

>   // Determine offset into packet contents.
>   if (ip_packet[9]==6) {
>       tcpHeader=(tcphdr *)(ip_packet+sizeof(ip));

Don't do this. There may be IP options extending the size of the IP
header. Use iphdr->ihl to find the IP header size in the same manner as
tcphdr->doff is used to find the size of the TCP header..

Regards
Henrik
