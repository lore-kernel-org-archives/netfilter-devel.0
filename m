From: Jeremy Kerr <jeremy@redfishsoftware.com.au>
Subject: [ANNOUNCE] nfsim - 20040209 snapshot
Date: Mon, 9 Feb 2004 15:36:32 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402091536.32954.jeremy@redfishsoftware.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Martin Josefsson <gandalf@wlug.westbo.se>, carlos@ufrnet.br
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

A new snapshot of the netfilter simulator project has been released: 20040209.

Changes for this snapshot:

* Modified wait_for_message to behave properly when select() returns EAGAIN or
  EINTR (thanks to Martin Josefsson for the patch)
* Inline help is now processed with a text stylesheet, rather than through
  links/lynx
* log() changed to nfsim_log() to reduce warnings
* Added reference to HOWTO in the README


Download from the nfsim website:

   http://www.ozlabs.org/~jk/projects/nfsim/


Jeremy
