From: "Wei koong Chai" <W.Chai@eim.surrey.ac.uk>
Subject: [libipq] parallel userspace program
Date: Fri, 18 Oct 2002 15:02:52 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <39672.131.227.89.21.1034949772.squirrel@www.ecm.surrey.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

Hi...

   I am wondering whether the userspace (QUEUE target) in the netfilter
architecture can support parallel libipq program. I mean, if i develop
a userspace program using libipq that takes some parameters, can i run
the program more than one time simultaneously with different
parameters?

   To be more specific, let's say i have 3 interfaces for my linux box
(eth0, eth1, eth2) where i have incoming packets from eth0 in which all
the packets are intercepted and passed on to the QUEUE target. Some
packets are for eth1 while others are for eth2. I need the packets to
be processed with different parameters for each interface. So, can i
run two copy of my program with different parameters such that the
QUEUE target would know what to do with each of the packet.

   Thanks.


*******************************************************************
Wei Koong CHAI
Networks Research Group,
Centre For Communication Systems Research (CCSR),
School of Electronics & Physical Sciences,
University Of Surrey,
Guildford,
Surrey, GU2 7XH,
United Kingdom.
Tel.: +44-(0)1483-300-800 Ext.: 3465; Fax: +44-(0)1483-686-011
E-mail: W.Chai@surrey.ac.uk;
Homepage: http://www.ee.surrey.ac.uk/Personal/W.Chai/
*******************************************************************
