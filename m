From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [MISSING FILE]   TARPIT help file
Date: Wed, 16 Apr 2003 21:40:08 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9E05F8.806@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_uwfC/uB69BmWsBMBai/i7A)"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_uwfC/uB69BmWsBMBai/i7A)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

   please add this file to P-O-M as it is missing.

Stephane.


--Boundary_(ID_uwfC/uB69BmWsBMBai/i7A)
Content-type: text/plain; name=ipt_TARPIT.patch.configure.help; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=ipt_TARPIT.patch.configure.help

CONFIG_IP_NF_FILTER
TARPIT target support
CONFIG_IP_NF_TARGET_TARPIT
  Adds a TARPIT target to iptables, which captures and holds
  incoming TCP connections using no local per-connection resources.
  Connections are accepted, but immediately switched to the persist
  state (0 byte window), in which the remote side stops sending data
  and asks to continue every 60-240 seconds.  Attempts to close the
  connection are ignored, forcing the remote side to time out the
  connection in 12-24 minutes.

  This offers similar functionality to LaBrea
  <http://www.hackbusters.net/LaBrea/> but doesn't require dedicated
  hardware or IPs.  Any TCP port that you would normally DROP or REJECT
  can instead become a tarpit.

--Boundary_(ID_uwfC/uB69BmWsBMBai/i7A)--
