From: "Robert K. Johnson" <johnson60@llnl.gov>
Subject: problems with MAC filtering of fragmented packets
Date: Mon, 30 Sep 2002 11:55:59 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.1.0.14.2.20020930114233.0209be00@poptop.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I have an embedded computer platform running Linux 2.4.3 and iptables
userland tools 1.2.4.  MAC address filtering does not appear to work for
fragmented packets.  Non-fragmented packets work fine.  Please let me
know if there is a minimum kernel version and iptables version that performs
MAC address filtering correctly for fragmented packets.

I have a wireless networking application.  I would like to first block all 
packets
except those with known MAC addresses.  I will then perform additional 
filtering
based on protocols, ip addresses, etc.  In other words, MAC address 
verification
is an initial check.  I created a user chain that I jump to immediately 
from both
the INPUT and FORWARD chains.  This user chain performs a RETURN jump
for matches with known MAC's and DROPs all others.  I created a user chain
for dropped packets to perform logging.  Using a commercial packet sniffer, 
I can
see that fragmented packets are not passing the MAC check when they should.
The resulting LOG shows an empty MAC address field.  I have seen old entries
in the mailing list archives that indicate MAC address matching does not 
work for
fragmented packets.  I was hoping that this problem was resolved since then.
I would like to know the oldest kernel and iptables version that works 
correctly.
I am limited on moving to the latest kernel and iptables because the embedded
platform requires special Linux drivers that I do not have source access for.
