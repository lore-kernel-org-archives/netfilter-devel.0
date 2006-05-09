From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: [POM] MMS conntrack/NAT update
Date: Tue, 09 May 2006 14:20:17 +0200
Message-ID: <11471772191487-git-send-email-heitzenberger@astaro.com>
Reply-To: Holger Eitzenberger <heitzenberger@astaro.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

what follows are two small changes to the MMS conntrack/NAT helper.

The first patch simply removes trailing whitespace and is therefore
just janitorial work.

The second patch adapts the helper to make it work with kernel
version 2.6.15.y.  It seems rather large, but it all boils down to the
expectation refcounting changes.  The other changes result from the
fact that I inverted an if-conditional to avoid a rather large if-block.
Please take a look at the refcounting changes.

Please apply, thanks!  /holger
