From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [ANNOUNCE] ipt_ACCOUNT 1.6 released
Date: Mon, 12 Jun 2006 14:59:29 +0200
Message-ID: <200606121459.29912.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hello,

I'm pleased to announce the release of ipt_ACCOUNT 1.6.
Due to popular request I ported it to kernel 2.6.

Get it while it's still hot:
http://www.intra2net.com/de/produkte/opensource/ipt_account/

Here is a list of changes since the last official release:
- Kernel 2.6 support
- Fix for /32 netmasks
- Improved error handling
- Patch-o-matic apt-like download repository


Please note: The code in the netfilter SVN tree is not updated anymore.
It will soon be completely replaced by the apt-like download repository.

Best regards,
Thomas Jarosch
