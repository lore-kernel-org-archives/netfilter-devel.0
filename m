From: Bolzoni Damiano <dbolzoni@almach.dsi.unive.it>
Subject: How to close connction in syn_table?
Date: Mon, 17 Jun 2002 12:47:12 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <02061712495100.00883@proxima.dsi.unive.it>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi, I would like to close connection in SYN_RECV state.
In order to do this, I look at syn_table, then call tcp_synq_drop but system
craches...
Does anyone know why?

damiano
