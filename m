From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: 03_linux-2.6.5.patch from CVS fails to patch 2.6.7
Date: Mon, 21 Jun 2004 16:22:08 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <066d01c45758$14b74470$2601010a@bluereef.local>
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

Hello,

03_linux-2.6.5.patch from a snapshot of patch-o-matic-ng taken from cvs
today fails to patch against a clean 2.6.7 tree. Has anybody else noticed
this? Can I assume that the 2.6.5 patch which has been marked as "mandatory"
has already been applied to the main Linus tree and thus there's something
wrong with patch-o-matic?
