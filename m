From: "Remco van Mook" <remco@virtu.nl>
Subject: filter for adding/checking TCP MD5 option
Date: Tue, 20 Jan 2004 12:12:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E1Aitrb-0004cA-00@services3.virtu.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0058_01C3DF4E.A7204960"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0058_01C3DF4E.A7204960
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit


Hello,

I'm currently starting work on building a netfilter addition that can add
the MD5 option field to a TCP connection. This is a 
rarely used option, best documented in RFC2385, and is to my knowledge only
used as a security mechanism for BGP sessions.
Linux is currently not able to support this. Unfortunately, it is quite
commonly used for BGP sessions.   

What I would like to be able to do is something like the following:

# iptables -t mangle -A OUTPUT -p tcp -d 1.2.3.4 --dport 179 -j TCPMD5
--md5-key=s3cr3t
# iptables -t mangle -A PREROUTING -p tcp -s 1.2.3.4 --dport 179 -j TCPMD5
--md5-key=s3cr3t

The first line would do something as follows:
- decrease MSS to make the extra option fit (a staggering 18 bytes extra in
the TCP header)
- calculate the MD5 based on the key and the information contained in the
packet
- insert the TCP MD5 option field, recalculate checksum and send the packet
on its way

The second line would:
- check whether the MD5 matches the key
- DROP the packet if it doesn't match
- if the MD5 matches, strip off the MD5 option field, recalculate checksum
and treat the packet as if nothing happened

As I'm a complete newbie when it comes to netfilter development, could
anybody provide me some pointers on how to do
this in the right way ? Borrowing code from TCPMSS and using the Crypto API
from the kernel for the MD5 checksum
are things I'm currently considering.

Thanks,

Remco van Mook

------=_NextPart_000_0058_01C3DF4E.A7204960
Content-Type: application/ms-tnef;
	name="winmail.dat"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="winmail.dat"

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
QVRDUENPTk5FQ1RJT04AAAAAP9w=

------=_NextPart_000_0058_01C3DF4E.A7204960--
