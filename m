From: Nils Radtke <Nils.Radtke@Think-Future.de>
Subject: local NAT
Date: Tue, 10 Jun 2003 00:33:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030610003356.A22098@marvin.informatik.uni-stuttgart.de>
Reply-To: Nils Radtke <Nils.Radtke@Think-Future.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

  Fact:
  inbound connection from net A on eth2 needs to be SNATted to net b
  (connected to eth0) as some local (box with eth0-2) services accept
  only net b.

  Is this already implemented? The only evidence in this topic seems to
  be an email dated 31 march 2002 stating that the implementor of local
  DNAT also did SNAT which was (by a member of ct) not considered
  worth getting into kernel.

  As understood, the NAT in the mentionned email is not exactly the
  required funtionality but close to it.

  Question:
  Is there code around implementing the feature of SNATting incoming
  packets for local processes?


    Hints are welcome! Thanks in advance.


      Nils Radtke


--=20

* N.Radtke@                 * University of Stuttgart *    icq / lc   *
*      www.Think-Future.de  *    dep.comp.science     * 9336272/92045 *
:x                                                                   :)

   I don't believe in natural science.   -- G=F6del, Kurt
