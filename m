From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: New match ipt_nexthop
Date: Wed, 15 Sep 2004 16:53:36 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4148ABD0.9070203@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080205040305020202050805"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080205040305020202050805
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Attached is a pom-ng style patch that makes possible to match the 
next-hop ipv4 of a packet.

Should work with both 2.4 and 2.6 but still in testing.

Notice that, for an unknown reason, the 2.6 Kconfig.ladd is appended to 
the end of Kconfig. I'll be quite happy if someone could fix it and tell 
me what was wrong. (I'm sorry for the inconvenient.)

Bad and good comments are welcome!

Thanks,

Samuel Jean
CookingLinux.org

--------------080205040305020202050805
Content-Type: application/x-gzip;
 name="nexthop-pomng.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="nexthop-pomng.tar.gz"

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
jDLKKKOMMsooo4wyWoD+B6YO1m0AeAAA
--------------080205040305020202050805--
