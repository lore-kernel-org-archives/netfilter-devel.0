From: "Miguel Angel Amador Lorca" <amador@puc.cl>
Subject: NAT on the same ethernet card ?
Date: Fri, 10 Jan 2003 14:30:32 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001801c2b8cd$fa819d00$7901000a@nivel5.cl>
References: <3DEBA04C.7080606@myrealbox.com> <20030110140544.GV1353@sunbeam.de.gnumonks.org>
Reply-To: "Miguel Angel Amador Lorca" <amador@puc.cl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
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

it' is possible that netfilter make NAT or MASQ over  a tcp-packet from the
one net (10.0.1.0) , and back to the same net (back to the 10.0.1.0 again )
?
                                                              ____________
My PC---->tcp request --->   eth0 -->  |                       |
(10.0.1.105)                                          |       FW          |-
eth1 -----------> - internet
                   MyWWW  <--eth0------   |___________
  -mydns
                    (10.0.1.100)




Miguel Angel Amador Lorca    |    mailto:amador@puc.cl
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCM d- s:+ a- C++++ UL+++ P- L+++ E--- W+++ N++ o K- w++
O- M- V- PS+ PE++ Y PGP- t 5 X+++ R !tv b+ DI- D
G++ e- h* r- y*
------END GEEK CODE BLOCK------
