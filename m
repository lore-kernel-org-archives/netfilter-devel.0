From: "Wei koong Chai" <eem1wc@eim.surrey.ac.uk>
Subject: {libipq] Netlink Connection Refused
Date: Fri, 27 Sep 2002 16:03:27 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <2222.131.227.74.158.1033139007.squirrel@www.ecm.surrey.ac.uk>
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

Hi again...

   I have developed a network emulator using libipq together with brctl
under Redhat Linux 7.2. It works fine. Recently, I am asked to install
my emulator for an old machine running Mandrake.

   The iptables of that machine isn't working and thus, it is re-installed
and works fine afterwards. Then i tried to run my emulator but received
an error message as below:

Netlink Connection Refused.

   This problem does not exist before the re-installation of the iptables.
I tried again with and without brctl but still receive the same error
message. So, my guess is that the communication between iptables with
the userspace is problematic. But i can't be sure. So, here i am asking
the experts what could be the real cause and how do i solve such
problems.


Thank you.



*I have subscribe the netfilter mailing list but without apparent reason,
i have not receive any mail from the list for quite some time already.
Thus, I would appreciate that the reply for this mail to be sent straight
to my mailbox. Thank you.
