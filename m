From: "Shipman, Jeffrey E" <jeshipm@sandia.gov>
Subject: a question on marking packets
Date: Tue, 9 Jul 2002 15:10:22 -0600
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <03781128C7B74B4DBC27C55859C9D73809840653@es06snlnt>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "'netfilter-devel@lists.samba.org'" <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I have a situation where I need to be able to
mark packets on the NF_IP_LOCAL_IN hook that
match certain patterns we will be watching
for. This because after accept the packet and 
the response packet is generated (NF_IP_LOCAL_OUT),
we must be able to know how to modify this packet
depending on the results from that incoming
packet. Does anyone have some advice how to properly
mark these packets so we can do this? Any tips
or direction on where to look would be most
appreciated.

TIA, 

Jeff Shipman - CCD
Sandia National Laboratories
(505) 844-1158 / MS-1372
