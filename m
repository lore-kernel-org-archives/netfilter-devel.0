From: "Eric Leblond" <eric@inl.fr>
Subject: [PATCH 1/3] ulogd2 update
Date: Tue, 10 Oct 2006 23:57:08 +0200 (CEST)
Message-ID: <4281.83.156.0.70.1160517428.squirrel@mail.inl.fr>
References: <2289.83.156.0.70.1160517260.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20061010235708_10479"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <2289.83.156.0.70.1160517260.squirrel@mail.inl.fr>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

------=_20061010235708_10479
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi,

This patch synchronizes ULOG input plugin with current ulogd2 API.

BR
--
Eric Leblond
INL : http://www.inl.fr
NuFW, Now User Filtering Works (http://www.nufw.org)
------=_20061010235708_10479
Content-Type: text/x-patch; name="ulogd2-sync-api.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="ulogd2-sync-api.patch"

=== input/packet/ulogd_inppkt_ULOG.c
==================================================================
--- input/packet/ulogd_inppkt_ULOG.c	(revision 4622)
+++ input/packet/ulogd_inppkt_ULOG.c	(revision 4623)
@@ -234,6 +234,7 @@
 	ui->ulog_fd.fd = ipulog_get_fd(ui->libulog_h);
 	ui->ulog_fd.cb = &ulog_read_cb;
 	ui->ulog_fd.data = upi;
+	ui->ulog_fd.when = ULOGD_FD_READ;
 
 	ulogd_register_fd(&ui->ulog_fd);
 
------=_20061010235708_10479--
