From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Subject: FYI: QUEUE & ipqmpd bugs
Date: Fri, 5 Jul 2002 16:08:54 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <003301c2242d$7fca2e40$0689cb8a@etbx180>
Reply-To: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>, <netfilter@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

FYI,

I upgraded to iptables-1.2.6a (user & kernel-2.4.18 patches)
and got the following (maybe known) problems:

- QUEUE target is NOK with kernel compiled with CONFIG_IP_NF_QUEUE=m
  => the packets are queued, but ipq_create_handle() returns 
     "can't create netlink socket"
     "ERROR: Unable to create netlink socket: Connection refused"
    (problem with exported symbols?)
  =>quick fix: compile kernel with CONFIG_IP_NF_QUEUE=y

- ipqmpd-0.3: default verdict NF_ACCEPT is not applied when no
  process has attached to it. In fact ipqmpd starts, but it seems
  that it never receives any packet (in ipq_inp). When one process
  attaches to it, with a mark different from the queued packet, then
  the default NF_ACCEPT is applied correctly. When all processes have
  detached from ipqmpd, the default NF_ACCEPT continues to be applied
  correctly.

kr,
_______________________________________________________________________
-jmhe-               He who expects nothing shall never be disappointed
