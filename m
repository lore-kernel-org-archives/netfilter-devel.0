From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ESP spi/sequence tracking and nat
Date: Tue, 10 Aug 2004 12:24:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4118A25C.5010103@eurodev.net>
References: <8FC831532CEE564AB88AC1D999C29DEBD9F148@prinsmail01.am.thmulti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kashyap Ashwin <Ashwin.Kashyap@thomson.net>
In-Reply-To: <8FC831532CEE564AB88AC1D999C29DEBD9F148@prinsmail01.am.thmulti.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Kashyap Ashwin wrote:

> 1. How can I figure out the direction of the packet in pkt_tuple(). 
> The idea is to store the SEQ/SPI values from the packet either into 
> tuple->src or tuple->dst. I noticed that packet() has a 
> ip_conntrack_info, but pkt_tuple() does not. I am not sure if I can 
> mess ip_conntrack in packet() instead…
>

AFAIK you can't, you know if a packet comes from the original/reply 
direction once you get the tuple from the conntrack table. Trace 
resolve_normal_ct:

1) we create a temporary tuple which will be used to match: get_tuple -> 
pkt_to_tuple
2) now, it's time to look up that tuple in the conntrack table: 
ip_conntrack_find_get

at 1) we don't know which direction the packet came from, we know it at 2).

Please correct me if I'm missing anything.


regards,
Pablo
