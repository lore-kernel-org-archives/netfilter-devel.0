From: David Stes <stes@pandora.be>
Subject: announce: HOWTO on Legato NetWorker firewall
Date: Sat, 3 Jan 2004 16:24:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040103162422.A5224@D5E02895.kabel.telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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


Hi,

I'd like to announce a document (HOWTO) on setting up a stateful
connection tracking Linux iptables/netfilter firewall for Legato NetWorker.

See:

	http://users.pandora.be/stes/nsrfw04.html

This is to set up an intelligent connection tracking firewall between
backup server (Linux or not) and clients (can also be non-Linux).

Alternatively, the HOWTO describes how to simply 'harden' a Linux Legato
NetWorker server, by installing netfilter on the backup server, and
protecting the Legato service ports.

The paper describes how ALL ports can be firewalled (protected) on the
backup server, and that only ONE port (7938) must be opened.

Regards,
David Stes
