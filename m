From: Tim Ozor <tozor@jetfuelsoftware.com>
Subject: [PATCH 2.6.11.2 1/1] ipt_sctp chunk map definition too large
Date: Wed, 09 Mar 2005 15:25:15 -0600
Message-ID: <422F69BB.3010301@jetfuelsoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Greetings,

In the process of implementing a native Java iptables API, I discovered 
a bug in the ipt_sctp.h header file where the chunkmap is defined too 
large. This obviously does not affect execution, but will result in 
increased memory useage in libiptc, or in my case the java process.

	Tim Ozor (tozor@jetfuelsoftware.com)


diff -uprN linux-2.6.11.2.orig/include/linux/netfilter_ipv4/ipt_sctp.h 
linux-2.6.11.2/include/linux/netfilter_ipv4/ipt_sctp.h
--- linux-2.6.11.2.orig/include/linux/netfilter_ipv4/ipt_sctp.h 
2005-03-09 14:55:57.367211471 -0600
+++ linux-2.6.11.2/include/linux/netfilter_ipv4/ipt_sctp.h 
2005-03-09 14:57:21.203988675 -0600
@@ -22,7 +22,7 @@ struct ipt_sctp_info {
         u_int16_t dpts[2];  /* Min, Max */
         u_int16_t spts[2];  /* Min, Max */

-       u_int32_t chunkmap[256 / sizeof (u_int32_t)];  /* Bit mask of 
chunks to be matched according to RFC 2960 */
+       u_int32_t chunkmap[256 / (sizeof(u_int32_t)*8)];  /* Bit mask of 
chunks to be matched according to RFC 2960 */

  #define SCTP_CHUNK_MATCH_ANY   0x01  /* Match if any of the chunk 
types are present */
  #define SCTP_CHUNK_MATCH_ALL   0x02  /* Match if all of the chunk 
types are present */
