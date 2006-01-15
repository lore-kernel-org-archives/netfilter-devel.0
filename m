From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: Simple coding question...
Date: Sun, 15 Jan 2006 13:31:46 +0100
Message-ID: <1137328306.23199.4.camel@scaramouche.combox.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Hello,

recently I studied the MARK and CLASSIFY targets and found these
lines doing the actual changes:

   if((*pskb)->nfmark != markinfo->mark)
      (*pskb)->nfmark = markinfo->mark;

   if((*pskb)->priority != clinfo->priority)
      (*pskb)->priority = clinfo->priority;

Is there a reason the value is always checked first?
Why not just write

   (*pskb)->something = my_value;

and save a few cycles? I'm just curious.

Greetings,
Torsten
