From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Subject: [PATCH -mm] lib/ts_fsm.c: constify structs
Date: Thu, 31 Aug 2006 20:27:34 +0200
Message-ID: <20060831182734.GA26228@rhlx01.fht-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Andrew Morton <akpm@osdl.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Constify two structs.
Correct some typos.

Compile-tested and run-tested (module inserted) on 2.6.18-rc4-mm3.


Signed-off-by: Andreas Mohr <andi@lisas.de>


--- linux-2.6.18-rc4-mm3.orig/lib/ts_fsm.c	2006-08-22 21:09:55.000000000 +0200
+++ linux-2.6.18-rc4-mm3/lib/ts_fsm.c	2006-09-08 19:46:07.000000000 +0200
@@ -12,13 +12,13 @@
  *
  *   A finite state machine consists of n states (struct ts_fsm_token)
  *   representing the pattern as a finite automation. The data is read
- *   sequentially on a octet basis. Every state token specifies the number
+ *   sequentially on an octet basis. Every state token specifies the number
  *   of recurrences and the type of value accepted which can be either a
  *   specific character or ctype based set of characters. The available
  *   type of recurrences include 1, (0|1), [0 n], and [1 n].
  *
- *   The algorithm differs between strict/non-strict mode specyfing
- *   whether the pattern has to start at the first octect. Strict mode
+ *   The algorithm differs between strict/non-strict mode specifying
+ *   whether the pattern has to start at the first octet. Strict mode
  *   is enabled by default and can be disabled by inserting
  *   TS_FSM_HEAD_IGNORE as the first token in the chain.
  *
@@ -44,7 +44,7 @@
 #define _W		0x200 /* wildcard */
 
 /* Map to _ctype flags and some magic numbers */
-static u16 token_map[TS_FSM_TYPE_MAX+1] = {
+static const u16 token_map[TS_FSM_TYPE_MAX+1] = {
 	[TS_FSM_SPECIFIC] = 0,
 	[TS_FSM_WILDCARD] = _W,
 	[TS_FSM_CNTRL]	  = _C,
@@ -61,7 +61,7 @@
 	[TS_FSM_ASCII]	  = _A,
 };
 
-static u16 token_lookup_tbl[256] = {
+static const u16 token_lookup_tbl[256] = {
 _W|_A|_C,      _W|_A|_C,     _W|_A|_C,     _W|_A|_C,		/*   0-  3 */
 _W|_A|_C,      _W|_A|_C,     _W|_A|_C,     _W|_A|_C,		/*   4-  7 */
 _W|_A|_C,      _W|_A|_C|_S,  _W|_A|_C|_S,  _W|_A|_C|_S,		/*   8- 11 */
