From: Patrick Schaaf <bof@bof.de>
Subject: SNAT and IP ID
Date: Fri, 2 May 2003 11:54:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030502095420.GI15143@oknodo.bof.de>
References: <20030502070651.GG15143@oknodo.bof.de> <20030502090512.834482C085@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030502090512.834482C085@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I have a question that seems too simple, somehow. Anyway, out with it:

Given a basic SNAT application, with two hosts on the left,
an iptables box in the middle, and a server to the right.
By using SNAT, both hosts's source IP addresses are changed
to a single shared source IP address, on the way from the
iptables box, to the server.

Every packet sent by our two hosts, has a 16-bit IP ID field,
for use in fragmentation and reassembly. Together with source and
destination IP addresses, the ID field provides the key under which
the server will gather incoming fragments belonging to the same
IP packet.

Now, consider both hosts sending out an IP packet with identical ID
field. Will the IDs be made unique by the SNAT process? If not, what
happens when, after the SNAT, the packets get fragmented on their
way to the server? The server cannot sanely reassemble.

Has this been discussed here, before?  Googling [1] results in quite a
set of hits that mention the issue, it seems customary to ignore it?

best regards
  Patrick

[1] http://www.google.de/search?q=NAT+fragmentation+problems+IP+ID
