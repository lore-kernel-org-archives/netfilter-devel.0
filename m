From: Filip Sneppe <filip.sneppe@cronos.be>
Subject: Re: mangle MSS via tcp_manip_pkt() in ip_nat_proto_tcp.c [patch]
Date: 18 Jul 2003 19:16:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1058548579.616.2.camel@sloth>
References: <BE229ADC976AC343830DFF9BC159FAEB011E46AA@KUEXCHANGE.kvhinternal.kvhi>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Glaum <mglaum@kvh.com>
In-Reply-To: <BE229ADC976AC343830DFF9BC159FAEB011E46AA@KUEXCHANGE.kvhinternal.kvhi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2003-07-18 at 16:57, Michael Glaum wrote:
[...] 
> I tried several things, e.g. pathMTU, etc but in view of severe time
> constraints I decided to HACK tcp_manip_pkt() in ip_nat_proto_tcp.c
> so that when it does source and destination address translation it also
> drops the MSS on outgoing and incoming packets to be below 1360. This
> appears to work. I didn't even bother to check if the packets had
> tcphdr->syn ==1 set.
> 
> Please advise if there is a more elegant way to do this!

Hi Michael,

The easiest way to achieve your goal is to use the TCPMSS target
(that exists in the standard kernel for a long time now) to set
the MSS of the packets going out via the satellite link.

Regards,
Filip
