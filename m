From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 0/4] Use bools for xt_match and xt_target
Date: Mon, 4 Jun 2007 17:09:51 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706041707410.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


(just an introductory message so that it looks nice in MUAs with thread 
support)

Along comes... a four-patch set that transforms:

  * xt_match->match(hotdrop) argument
  * xt_match->match() return type
  * xt_match->checkentry() return type
  * xt_target->checkentry() return type

to booleans, because that is all they do right now.


	Jan
-- 
