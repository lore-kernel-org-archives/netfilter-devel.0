From: Patrick Schaaf <bof@bof.de>
Subject: Re: L2TP protocol source port number changed
Date: Thu, 22 May 2003 08:10:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030522061046.GB24297@oknodo.bof.de>
References: <3ECC5A67.5000803@cobra.ee.ntu.edu.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ChungLiang <david@cobra.ee.ntu.edu.tw>
Content-Disposition: inline
In-Reply-To: <3ECC5A67.5000803@cobra.ee.ntu.edu.tw>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

ChungLiang & all,

my previous mail was a bit wrong on the real problem with L2TP:

Seeing the initial tunnel establishment packet from LAC to LNS,
one can NOT infer the IP address and port that the LNS will use
for the second, acknowledging, packet. The LNS is free to choose
one, it just has to answer back to the LAC and the port the LAC
used in the initial packet.

Thus, no exact expectation can be set up by inspecting the
initial packet; you need to capture any UDP traffic flowing
back to the initial LAC IP/port, and use the source information
of that captured packet to then set up the expectation.

Does the current NAT core allow such a partial expectation setup?

best regards
  Patrick
