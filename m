From: cranium 2003 <cranium.2003@gmail.com>
Subject: TCP/IP Packet sending ARP resolve
Date: Fri, 4 Feb 2005 08:09:12 +0530
Message-ID: <1d55641b0502031839404a7537@mail.gmail.com>
Reply-To: cranium 2003 <cranium.2003@gmail.com>
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

 Hello sir,
                   In Linux kernel by adding debug statement i observe
that if i ping to host 10.0.0.5 with 10 packets then first i know
network stack require to resolve hosts IP to its Hardware ID by
sending ARP on Ethernet LAN. But then what i get that if i again ping
for another 10 packets to 10.0.0.5 then ARP routine is called.
               Why? Why linux kernel is not caching it. Infact its
caching i check it in debug statements then why network stack require
to resolve 10.0.0.5 host to send packets to it?

                Also i want to know once eth_header_cache called then
all successive packet to that cache host goes directly from
hh->hh_output(skb) to hard_start_xmit?
regards,
cranium
