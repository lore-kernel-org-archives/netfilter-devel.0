From: Padraig@Linux.ie
Subject: invalid packets
Date: Fri, 16 May 2003 17:38:39 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EC5140F.1030203@Linux.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi, under what circumstances would iptraf (PF_PACKET)
be able to recieve packets on an interface, and
for those same packets to be not registered
with netfilter at all. I'm setting the filter on
the PREROUTING chain in the mangle table and no
packets are registered?

I have a suspicion that the checksums in the packets
are incorrect, so would this cause it, and any
work arounds (so I can just match ip addresses
for e.g. and then drop the packet).

Hmm I suppose if the checksum is wrong you can't depend
on anything, but I'm just surprised iptraf can
log them which netfilter can't.

cheers,
P=E1draig.
