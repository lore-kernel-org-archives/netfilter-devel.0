From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 00/11] Minor Cleanups
Date: Wed, 01 Nov 2006 22:08:45 +0100
Message-ID: <20061101210845.337590368@wlug.westbo.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
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

The following patches clean up nf_conntrack a little bit. The first patches
split out various parts into their own separate files. Then some small cleanups
follow and lastly there's a small optimization.

--
/Martin
